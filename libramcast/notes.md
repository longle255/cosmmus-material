# Notes

## Todo

### Implementations
- [x] Leader write timestamps to group processes and other involved leader
- [x] Leader propagates timestamps from other leaders to group processes
- [x] Processes write their acks when receive ts
- [x] Processes reads timestamps in order
- [ ] Client writes slot# where the message is written on other shared buffered, instead of writing absolute addresses.

## Notes

- Followers only receive timestamp from their own leader => only need to keep counter of leader.
- If leader fails, new leader has to send their counter to follower

## Problems & Solutions

### *Why do we need to write to leader first, then propagate?*

Assume P1.1 is leader of group G1, P2.1 is leader of group G2.

- P1.1 keeps local timestamp 10

- P2.1 keeps local timestamp 8

Client wants to multicast message m1 => writes m1 to all processes of 2 groups

- Once P1.1 reads m1, P1.1 picks ts 10, writes to all other processes.

- Once P2.1 reads m1, P2.1 picks ts 8, writes to all other processes.

All processes send acks to other processes once receive timestamp.

**Before the "write" ts 10 of P1.1 is done on P2.1 (it is done on P2.2, P2.3), new message arrives on group G2.**

P2.1 has not seen ts 10 => P2.1 picks ts 9, assign to m2, and writes to P2.1, P2.2, P2.3

It might happen the case: P2.1, P2.2, P2.3 see ts 9 on m2, accept it, send acks to other process of group G2.
msg format:

```
╔═════╦═════╦════════╦═══════╦════════╦═══════╦════════╦════════╦════════╗
║  m  ║ ts1 ║ ack1.1 ║ ack1.2║ ack1.3 ║  ts2  ║ ack2.1 ║ ack2.2 ║ ack2.3 ║
╚═════╩═════╩════════╩═══════╩════════╩═══════╩════════╩════════╩════════╝
```

```
              ╔════╦═════╦════════╦════════╦════════╦═════╦════════╦════════╦════════╗
P1.1*         ║ m1 ║ 10  ║ 1.1 ok ║ 1.2 ok ║ 1.3 ok ║  8  ║ xxxxxx ║ 2.2 ok ║ 2.3 ok ║
              ╚════╩═════╩════════╩════════╩════════╩═════╩════════╩════════╩════════╝
              ╔════╦═════╦════════╦════════╦════════╦═════╦════════╦════════╦════════╗
P1.2          ║ m1 ║ 10  ║ 1.1 ok ║ 1.2 ok ║ 1.3 ok ║  8  ║ xxxxxx ║ 2.2 ok ║ 2.3 ok ║
              ╚════╩═════╩════════╩════════╩════════╩═════╩════════╩════════╩════════╝
              ╔════╦═════╦════════╦════════╦════════╦═════╦════════╦════════╦════════╗
P1.3          ║ m1 ║ 10  ║ 1.1 ok ║ 1.2 ok ║ 1.3 ok ║  8  ║ xxxxxx ║ 2.2 ok ║ 2.3 ok ║
              ╚════╩═════╩════════╩════════╩════════╩═════╩════════╩════════╩════════╝


              ╔════╦═════╦════════╦════════╦════════╦═════╦════════╦════════╦════════╗  ╔════╦═════╦════════╦════════╦════════╗
P2.1*         ║ m1 ║ xxx ║ 1.1 ok ║ 1.2 ok ║ 1.3 ok ║  8  ║ xxxxxx ║ 2.2 ok ║ 2.3 ok ║  ║ m2 ║  9  ║ 2.1 ok ║ 2.2 ok ║ 2.3 ok ║
              ╚════╩═════╩════════╩════════╩════════╩═════╩════════╩════════╩════════╝  ╚════╩═════╩════════╩════════╩════════╝
              ╔════╦═════╦════════╦════════╦════════╦═════╦════════╦════════╦════════╗  ╔════╦═════╦════════╦════════╦════════╗
P2.2          ║ m1 ║ 10  ║ 1.1 ok ║ 1.2 ok ║ 1.3 ok ║  8  ║ xxxxxx ║ 2.2 ok ║ 2.3 ok ║  ║ m2 ║  9  ║ 2.1 ok ║ 2.2 ok ║ 2.3 ok ║
              ╚════╩═════╩════════╩════════╩════════╩═════╩════════╩════════╩════════╝  ╚════╩═════╩════════╩════════╩════════╝
              ╔════╦═════╦════════╦════════╦════════╦═════╦════════╦════════╦════════╗  ╔════╦═════╦════════╦════════╦════════╗
P2.3          ║ m1 ║ 10  ║ 1.1 ok ║ 1.2 ok ║ 1.3 ok ║  8  ║ xxxxxx ║ 2.2 ok ║ 2.3 ok ║  ║ m2 ║  9  ║ 2.1 ok ║ 2.2 ok ║ 2.3 ok ║
              ╚════╩═════╩════════╩════════╩════════╩═════╩════════╩════════╩════════╝  ╚════╩═════╩════════╩════════╩════════╝
```

- On P2.1, it has not seen ts 10 on msg m1 => m2 is the only one get enough acks with ts 9 => deliver m2
- On P2.2, P2.3: receives all ts and all acks for m1 before m2 arrives => delive m1.


════════════════════════════════════════════════════════════════════════════

How does the propagation timestamp by leader fix that?

- P2.2 and P2.3 will not deliver m1 until the ts has been written by P2.1

- If P2.1 sees ts 10 of m1 first, it then can set ts 11 for m2, instead of 9.
- If P2.1 sees m2 first, it can set ts 9 for m2, then propagates ts 10 of m1 AFTER propagating 9 of m2.

** it might happen that event P2.1 writes ts 9 of m2 BEFORE ts 10 of m1, P2.2 and P2.3 still could receive 10 before 9
=> still deliver m1 before m2
==> P2.2 and P2.3 needs to read ts in the order that P2.1 writes

=> put a counter for the "write" of P2.1. Everytime P2.1 writes the ts, it include the counter.
P2.2 and P2.3 read the ts follow the counter order

```
              ╔════╦═════╦════════╦════════╦════════╦═════╦════════╦════════╦════════╗
P1.1*         ║ m1 ║ 10  ║ 1.1 ok ║ 1.2 ok ║ 1.3 ok ║  8  ║ xxxxxx ║ 2.2 ok ║ 2.3 ok ║
              ╚════╩═════╩════════╩════════╩════════╩═════╩════════╩════════╩════════╝
              ╔════╦═════╦════════╦════════╦════════╦═════╦════════╦════════╦════════╗
P1.2          ║ m1 ║ 10  ║ 1.1 ok ║ 1.2 ok ║ 1.3 ok ║  8  ║ xxxxxx ║ 2.2 ok ║ 2.3 ok ║
              ╚════╩═════╩════════╩════════╩════════╩═════╩════════╩════════╩════════╝
              ╔════╦═════╦════════╦════════╦════════╦═════╦════════╦════════╦════════╗
P1.3          ║ m1 ║ 10  ║ 1.1 ok ║ 1.2 ok ║ 1.3 ok ║  8  ║ xxxxxx ║ 2.2 ok ║ 2.3 ok ║
              ╚════╩═════╩════════╩════════╩════════╩═════╩════════╩════════╩════════╝
```

Case 1: m2 arrives BEFORE P2.1* recieves ts 10

```
              ╔════╦═══════╦════════╦════════╦════════╦═══════╦════════╦════════╦════════╗  ╔════╦═══════╦════════╦════════╦════════╗
P2.1*         ║ m1 ║ 10,?  ║ 1.1 ok ║ 1.2 ok ║ 1.3 ok ║  8,4  ║ xxxxxx ║ 2.2 ok ║ 2.3 ok ║  ║ m2 ║  9,5  ║ 2.1 ok ║ 2.2 ok ║ 2.3 ok ║
              ╚════╩═══════╩════════╩════════╩════════╩═══════╩════════╩════════╩════════╝  ╚════╩═══════╩════════╩════════╩════════╝
              ╔════╦═══════╦════════╦════════╦════════╦═══════╦════════╦════════╦════════╗  ╔════╦═══════╦════════╦════════╦════════╗
P2.2          ║ m1 ║ 10,6  ║ 1.1 ok ║ 1.2 ok ║ 1.3 ok ║  8,4  ║ xxxxxx ║ 2.2 ok ║ 2.3 ok ║  ║ m2 ║  9,5  ║ 2.1 ok ║ 2.2 ok ║ 2.3 ok ║
              ╚════╩═══════╩════════╩════════╩════════╩═══════╩════════╩════════╩════════╝  ╚════╩═══════╩════════╩════════╩════════╝
              ╔════╦═══════╦════════╦════════╦════════╦═══════╦════════╦════════╦════════╗  ╔════╦═══════╦════════╦════════╦════════╗
P2.3          ║ m1 ║ 10,6  ║ 1.1 ok ║ 1.2 ok ║ 1.3 ok ║  8,4  ║ xxxxxx ║ 2.2 ok ║ 2.3 ok ║  ║ m2 ║  9,5  ║ 2.1 ok ║ 2.2 ok ║ 2.3 ok ║
              ╚════╩═══════╩════════╩════════╩════════╩═══════╩════════╩════════╩════════╝  ╚════╩═══════╩════════╩════════╩════════╝
```

P2.1* propagate ts 9 for m2 with counter of 5, ts 10 of m1 with c=6
P2.2 and P2.3 could receive all ts and acks for m1 before receive m2.
But they will need to wait for counter of value 5.


Case 1: m2 arrives AFTER P2.1* recieves ts 10
```
              ╔════╦═══════╦════════╦════════╦════════╦═══════╦════════╦════════╦════════╗  ╔════╦════════╦════════╦════════╦════════╗
P2.1*         ║ m1 ║ 10,?  ║ 1.1 ok ║ 1.2 ok ║ 1.3 ok ║  8,4  ║ xxxxxx ║ 2.2 ok ║ 2.3 ok ║  ║ m2 ║  11,5  ║ 2.1 ok ║ 2.2 ok ║ 2.3 ok ║
              ╚════╩═══════╩════════╩════════╩════════╩═══════╩════════╩════════╩════════╝  ╚════╩════════╩════════╩════════╩════════╝
              ╔════╦═══════╦════════╦════════╦════════╦═══════╦════════╦════════╦════════╗  ╔════╦════════╦════════╦════════╦════════╗
P2.2          ║ m1 ║ 10,6  ║ 1.1 ok ║ 1.2 ok ║ 1.3 ok ║  8,4  ║ xxxxxx ║ 2.2 ok ║ 2.3 ok ║  ║ m2 ║  11,5  ║ 2.1 ok ║ 2.2 ok ║ 2.3 ok ║
              ╚════╩═══════╩════════╩════════╩════════╩═══════╩════════╩════════╩════════╝  ╚════╩════════╩════════╩════════╩════════╝
              ╔════╦═══════╦════════╦════════╦════════╦═══════╦════════╦════════╦════════╗  ╔════╦════════╦════════╦════════╦════════╗
P2.3          ║ m1 ║ 10,6  ║ 1.1 ok ║ 1.2 ok ║ 1.3 ok ║  8,4  ║ xxxxxx ║ 2.2 ok ║ 2.3 ok ║  ║ m2 ║  11,5  ║ 2.1 ok ║ 2.2 ok ║ 2.3 ok ║
              ╚════╩═══════╩════════╩════════╩════════╩═══════╩════════╩════════╩════════╝  ╚════╩════════╩════════╩════════╩════════╝
```

P2.2 and P2.3 could receive all ts and acks for m1 before receive m2.
But they will need to wait for counter of value 5.

## Message size increases with number of destinations

Message size: adding addresses of all processes in the message increase the size of the message significantly

Example of a message with 2 groups, 2 processes per group. It cost 2 * 2 * 8 bytes for addresses
```
╔════════╦════════╦════════════════╦═════════════╦═════════════╦═══════════════════════════════════════════════════════════════════════╦════════════╦═══════════════════════════════╦═══════════════════════════════════════════════╗
║ id=962 ║ len=6  ║ gCount=2       ║ AAA         ║ 0    │ 1    ║ 140665081851888 │ 140501671660992 │ 139704552803616 │ 139799176205904 ║     68     ║   1   |   4   ║   0   |   4   ║     0     │     0     │     0     │     0     ║
╠════════╬════════╬════════════════╬═════════════╬═════════════╬═══════════════════════════════════════════════════════════════════════╬════════════╬═══════════════════════════════╬═══════════════════════════════════════════════╣
║   4    ║   4    ║     2          ║    6        ║    2 * 2    ║                               8 * 2 * 2                               ║      4     ║    (4+4) * 2                  ║     2 * r * n                                 ║
╠════════╬════════╬════════════════╬═════════════╬═════════════╬═══════════════════════════════════════════════════════════════════════╬════════════╬═══════════════════════════════╬═══════════════════════════════════════════════╣
║  id    ║ length ║ groupCount (n) ║ message (m) ║ g[0] │ g[1] ║ offset[0][0]    │ offset[0][1]    │ offset[1][0]    │ offset[1][1]    ║ lengthCheck║ ts[0] | cw[0] ║ ts[1] | cw[1] ║ ack[0][0] │ ack[0][1] │ ack[1][0] │ ack[1][1] ║
╚════════╩════════╩════════════════╩═════════════╩═════════════╩═══════════════════════════════════════════════════════════════════════╩════════════════════════════════════════════╩═══════════════════════════════════════════════╝
```

FIX:

Client find a way to write the *slot number* in the shared memory space, instead of the absolute addresses
