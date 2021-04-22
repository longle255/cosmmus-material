# Notes

## Todo

### Implementations
- [x] Leader write timestamps to group processes and other involved leader
- [x] Leader propagates timestamps from other leaders to group processes
- [x] Processes write their acks when receive ts
- [x] Processes reads timestamps in order
- [x] Inlining data in work request for step 2 & 3
- [ ] Leader wait for all ts to be available before propagating. That reduces the writes on the server.
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

## Whitebox Multicast

![Result](https://i.imgur.com/6jfLXTB.png)

>> As my understanding,  in the experiment reported in the paper there are
ten groups, and for 2-group-destination test, the clients will share
the load among 5 of 2-groups.

> Wrong, we use 10 of 2-groups. {(0,1),(1,2),...,(8,9),(9,0)}


>> If that is true, could I assume that for a same 10-group cluster, I should
have around 40k msg/s * 5 = 200k msg/s.? Do those numbers make sense to
you?

> In the paper, we have around 500kmsgs/sec for the aggregated throughput. Since we use 10 client hosts, each of them had around 50kmsgs/sec throughput. Your results are looking somewhat close to what we got, to me.

## Selective signaling
One may notice that, within the post_send function implementation in "ib.c", we set the send_flags to be IBV_SEND_SIGNALED. As a result, each send operation also generates a completion event when it is finished (when the message has been delivered to the receiver and an acknowledgement is sent back to the sender).

Since the completion events of the sends are not relevant, we can get ride of the notification of such events by not setting send_flags (the default behavior is not signaled)

However, we can not use unsignaled sends all the time. Under the current libverbs implementation, a send operation is only considered to be completed when a completion event of this operation is generated and polled from the CQ. If one kept posting unsignaled sends, the send queue will eventually be full because none of these operations would be thought as completed and hence they remain in the send queue; and as a result, no more sends can be posted to the send queue. It also happens when one uses signaled sends but not polling any completion events from the CQ. As a result, a common practice is to use selective signaling, where a signaled send is posted once in a while, and then poll its completion event from the CQ. After the completion event of the signaled send is polled from CQ, all previous sends are considered to be completed and thus are removed from the send queue. Unsignaled sends have less overhead compared to signaled sends, therefore, selective signaling tends to have better performance

http://www.rdmamojo.com/2014/06/30/working-unsignaled-completions/

https://github.com/jcxue/RDMA-Tutorial/wiki#selective-signaling


## Data inlining

Sending inline'd data is an implementation extension that isn't defined in any RDMA specification: it allows send the data itself in the Work Request (instead the scatter/gather entries) that is posted to the RDMA device. The memory that holds this message doesn't have to be registered. There isn't any verb that specifies the maximum message size that can be sent inline'd in a QP. Some of the RDMA devices support it. In some RDMA devices, creating a QP with will set the value of max_inline_data to the size of messages that can be sent using the requested number of scatter/gather elements of the Send Queue. If others, one should specify explicitly the message size to be sent inline before the creation of a QP. for those devices, it is advised to try to create the QP with the required message size and continue to decrease it if the QP creation fails. While a WR is considered outstanding:

+ If the WR sends data, the local memory buffers content shouldn't be changed since one doesn't know when the RDMA device will stop reading from it (one exception is inline data)
+ If the WR reads data, the local memory buffers content shouldn't be read since one doesn't know when the RDMA device will stop writing new content to it

```
sequenceDiagram
    participant CPU1
    participant MEM1
    participant RNIC1
    participant RNIC2
    participant MEM2
    participant CPU2


rect rgb(0,100, 0, 0.1)
    Note over RNIC1, RNIC2: SEND / RECEIVE
    CPU1 -->> RNIC1: new SendRequest(SR)
    RNIC1 -->> +MEM1: DMA
    MEM1 -->> -RNIC1: 
    RNIC1 ->> RNIC2: RDMA Data Package
    RNIC2 -->> +MEM2: DMA
    MEM2 -->> -RNIC2: 
    RNIC2 -->> CPU2: CompletionEvent
    RNIC2 ->> RNIC1: RDMA ACK
    RNIC1 -->> CPU1: CompletionEvent
end
rect rgb(255,0, 255, 0.1)
    Note over RNIC1, RNIC2: READ, RELIABLE CHANNEL (RC)
    CPU1 -->> RNIC1: new SendRequest(SR)
    RNIC1 ->> RNIC2: RDMA Data Package
    RNIC2 -->> +MEM2: DMA
    MEM2 -->> -RNIC2: 
    RNIC2 ->> RNIC1: RDMA ACK
    RNIC1 -->> CPU1: CompletionEvent (CE)
end

rect rgb(0,0, 255, 0.1)
    Note over RNIC1, RNIC2: WRITE, RC, SIGNALED
    CPU1 -->> RNIC1: new SendRequest(SR)
    RNIC1 -->> +MEM1: DMA
    MEM1 -->> -RNIC1: 
    RNIC1 ->> RNIC2: RDMA Data Package
    RNIC2 -->> MEM2: DMA
    RNIC2 ->> RNIC1: RDMA ACK
    RNIC1 -->> CPU1: CompletionEvent (CE)
end

rect rgb(0,0, 255, 0.1)
    Note over RNIC1, RNIC2: WRITE, RC, UNSIGNALED
    CPU1 -->> RNIC1: new SendRequest(SR)
    RNIC1 -->> +MEM1: DMA
    MEM1 -->> -RNIC1: 
    RNIC1 ->> RNIC2: RDMA Data Package
    RNIC2 -->> MEM2: DMA
    RNIC2 ->> RNIC1: RDMA ACK
end


rect rgb(0,255, 155, 0.1)
    Note over RNIC1, RNIC2: WRITE, INLINED, UC, UNSIGNALED
    CPU1 -->> RNIC1: new SendRequest(SR)
    RNIC1 ->> RNIC2: RDMA Data Package
    RNIC2 -->> MEM2: DMA
end

rect rgb(0,100, 155, 0.1)
    Note over RNIC1, RNIC2: WRITE WITH IMM, INLINED, RC, SIGNALED
    CPU1 -->> RNIC1: new SendRequest(SR)
    RNIC1 ->> RNIC2: RDMA Data Package
    RNIC2 -->> MEM2: DMA
    RNIC2 -->> CPU2: Immediate value
    RNIC2 ->> RNIC1: RDMA ACK
end

```
[Edit](https://mermaid-js.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoic2VxdWVuY2VEaWFncmFtXG4gICAgcGFydGljaXBhbnQgQ1BVMVxuICAgIHBhcnRpY2lwYW50IE1FTTFcbiAgICBwYXJ0aWNpcGFudCBSTklDMVxuICAgIHBhcnRpY2lwYW50IFJOSUMyXG4gICAgcGFydGljaXBhbnQgTUVNMlxuICAgIHBhcnRpY2lwYW50IENQVTJcblxuXG5yZWN0IHJnYigwLDEwMCwgMCwgMC4xKVxuICAgIE5vdGUgb3ZlciBSTklDMSwgUk5JQzI6IFNFTkQgLyBSRUNFSVZFXG4gICAgQ1BVMSAtLT4-IFJOSUMxOiBuZXcgU2VuZFJlcXVlc3QoU1IpXG4gICAgUk5JQzEgLS0-PiArTUVNMTogRE1BXG4gICAgTUVNMSAtLT4-IC1STklDMTogXG4gICAgUk5JQzEgLT4-IFJOSUMyOiBSRE1BIERhdGEgUGFja2FnZVxuICAgIFJOSUMyIC0tPj4gK01FTTI6IERNQVxuICAgIE1FTTIgLS0-PiAtUk5JQzI6IFxuICAgIFJOSUMyIC0tPj4gQ1BVMjogQ29tcGxldGlvbkV2ZW50XG4gICAgUk5JQzIgLT4-IFJOSUMxOiBSRE1BIEFDS1xuICAgIFJOSUMxIC0tPj4gQ1BVMTogQ29tcGxldGlvbkV2ZW50XG5lbmRcbnJlY3QgcmdiKDI1NSwwLCAyNTUsIDAuMSlcbiAgICBOb3RlIG92ZXIgUk5JQzEsIFJOSUMyOiBSRUFELCBSRUxJQUJMRSBDSEFOTkVMIChSQylcbiAgICBDUFUxIC0tPj4gUk5JQzE6IG5ldyBTZW5kUmVxdWVzdChTUilcbiAgICBSTklDMSAtPj4gUk5JQzI6IFJETUEgRGF0YSBQYWNrYWdlXG4gICAgUk5JQzIgLS0-PiArTUVNMjogRE1BXG4gICAgTUVNMiAtLT4-IC1STklDMjogXG4gICAgUk5JQzIgLT4-IFJOSUMxOiBSRE1BIEFDS1xuICAgIFJOSUMxIC0tPj4gQ1BVMTogQ29tcGxldGlvbkV2ZW50IChDRSlcbmVuZFxuXG5yZWN0IHJnYigwLDAsIDI1NSwgMC4xKVxuICAgIE5vdGUgb3ZlciBSTklDMSwgUk5JQzI6IFdSSVRFLCBSQywgU0lHTkFMRURcbiAgICBDUFUxIC0tPj4gUk5JQzE6IG5ldyBTZW5kUmVxdWVzdChTUilcbiAgICBSTklDMSAtLT4-ICtNRU0xOiBETUFcbiAgICBNRU0xIC0tPj4gLVJOSUMxOiBcbiAgICBSTklDMSAtPj4gUk5JQzI6IFJETUEgRGF0YSBQYWNrYWdlXG4gICAgUk5JQzIgLS0-PiBNRU0yOiBETUFcbiAgICBSTklDMiAtPj4gUk5JQzE6IFJETUEgQUNLXG4gICAgUk5JQzEgLS0-PiBDUFUxOiBDb21wbGV0aW9uRXZlbnQgKENFKVxuZW5kXG5cbnJlY3QgcmdiKDAsMCwgMjU1LCAwLjEpXG4gICAgTm90ZSBvdmVyIFJOSUMxLCBSTklDMjogV1JJVEUsIFJDLCBVTlNJR05BTEVEXG4gICAgQ1BVMSAtLT4-IFJOSUMxOiBuZXcgU2VuZFJlcXVlc3QoU1IpXG4gICAgUk5JQzEgLS0-PiArTUVNMTogRE1BXG4gICAgTUVNMSAtLT4-IC1STklDMTogXG4gICAgUk5JQzEgLT4-IFJOSUMyOiBSRE1BIERhdGEgUGFja2FnZVxuICAgIFJOSUMyIC0tPj4gTUVNMjogRE1BXG4gICAgUk5JQzIgLT4-IFJOSUMxOiBSRE1BIEFDS1xuZW5kXG5cblxucmVjdCByZ2IoMCwyNTUsIDE1NSwgMC4xKVxuICAgIE5vdGUgb3ZlciBSTklDMSwgUk5JQzI6IFdSSVRFLCBJTkxJTkVELCBVQywgVU5TSUdOQUxFRFxuICAgIENQVTEgLS0-PiBSTklDMTogbmV3IFNlbmRSZXF1ZXN0KFNSKVxuICAgIFJOSUMxIC0-PiBSTklDMjogUkRNQSBEYXRhIFBhY2thZ2VcbiAgICBSTklDMiAtLT4-IE1FTTI6IERNQVxuZW5kXG5cbnJlY3QgcmdiKDAsMTAwLCAxNTUsIDAuMSlcbiAgICBOb3RlIG92ZXIgUk5JQzEsIFJOSUMyOiBXUklURSBXSVRIIElNTSwgSU5MSU5FRCwgUkMsIFNJR05BTEVEXG4gICAgQ1BVMSAtLT4-IFJOSUMxOiBuZXcgU2VuZFJlcXVlc3QoU1IpXG4gICAgUk5JQzEgLT4-IFJOSUMyOiBSRE1BIERhdGEgUGFja2FnZVxuICAgIFJOSUMyIC0tPj4gTUVNMjogRE1BXG4gICAgUk5JQzIgLS0-PiBDUFUyOiBJbW1lZGlhdGUgdmFsdWVcbiAgICBSTklDMiAtPj4gUk5JQzE6IFJETUEgQUNLXG5lbmRcbiIsIm1lcm1haWQiOnsidGhlbWUiOiJkZWZhdWx0IiwidGhlbWVWYXJpYWJsZXMiOnsiYmFja2dyb3VuZCI6IndoaXRlIiwicHJpbWFyeUNvbG9yIjoiI0VDRUNGRiIsInNlY29uZGFyeUNvbG9yIjoiI2ZmZmZkZSIsInRlcnRpYXJ5Q29sb3IiOiJoc2woODAsIDEwMCUsIDk2LjI3NDUwOTgwMzklKSIsInByaW1hcnlCb3JkZXJDb2xvciI6ImhzbCgyNDAsIDYwJSwgODYuMjc0NTA5ODAzOSUpIiwic2Vjb25kYXJ5Qm9yZGVyQ29sb3IiOiJoc2woNjAsIDYwJSwgODMuNTI5NDExNzY0NyUpIiwidGVydGlhcnlCb3JkZXJDb2xvciI6ImhzbCg4MCwgNjAlLCA4Ni4yNzQ1MDk4MDM5JSkiLCJwcmltYXJ5VGV4dENvbG9yIjoiIzEzMTMwMCIsInNlY29uZGFyeVRleHRDb2xvciI6IiMwMDAwMjEiLCJ0ZXJ0aWFyeVRleHRDb2xvciI6InJnYig5LjUwMDAwMDAwMDEsIDkuNTAwMDAwMDAwMSwgOS41MDAwMDAwMDAxKSIsImxpbmVDb2xvciI6IiMzMzMzMzMiLCJ0ZXh0Q29sb3IiOiIjMzMzIiwibWFpbkJrZyI6IiNFQ0VDRkYiLCJzZWNvbmRCa2ciOiIjZmZmZmRlIiwiYm9yZGVyMSI6IiM5MzcwREIiLCJib3JkZXIyIjoiI2FhYWEzMyIsImFycm93aGVhZENvbG9yIjoiIzMzMzMzMyIsImZvbnRGYW1pbHkiOiJcInRyZWJ1Y2hldCBtc1wiLCB2ZXJkYW5hLCBhcmlhbCIsImZvbnRTaXplIjoiMTZweCIsImxhYmVsQmFja2dyb3VuZCI6IiNlOGU4ZTgiLCJub2RlQmtnIjoiI0VDRUNGRiIsIm5vZGVCb3JkZXIiOiIjOTM3MERCIiwiY2x1c3RlckJrZyI6IiNmZmZmZGUiLCJjbHVzdGVyQm9yZGVyIjoiI2FhYWEzMyIsImRlZmF1bHRMaW5rQ29sb3IiOiIjMzMzMzMzIiwidGl0bGVDb2xvciI6IiMzMzMiLCJlZGdlTGFiZWxCYWNrZ3JvdW5kIjoiI2U4ZThlOCIsImFjdG9yQm9yZGVyIjoiaHNsKDI1OS42MjYxNjgyMjQzLCA1OS43NzY1MzYzMTI4JSwgODcuOTAxOTYwNzg0MyUpIiwiYWN0b3JCa2ciOiIjRUNFQ0ZGIiwiYWN0b3JUZXh0Q29sb3IiOiJibGFjayIsImFjdG9yTGluZUNvbG9yIjoiZ3JleSIsInNpZ25hbENvbG9yIjoiIzMzMyIsInNpZ25hbFRleHRDb2xvciI6IiMzMzMiLCJsYWJlbEJveEJrZ0NvbG9yIjoiI0VDRUNGRiIsImxhYmVsQm94Qm9yZGVyQ29sb3IiOiJoc2woMjU5LjYyNjE2ODIyNDMsIDU5Ljc3NjUzNjMxMjglLCA4Ny45MDE5NjA3ODQzJSkiLCJsYWJlbFRleHRDb2xvciI6ImJsYWNrIiwibG9vcFRleHRDb2xvciI6ImJsYWNrIiwibm90ZUJvcmRlckNvbG9yIjoiI2FhYWEzMyIsIm5vdGVCa2dDb2xvciI6IiNmZmY1YWQiLCJub3RlVGV4dENvbG9yIjoiYmxhY2siLCJhY3RpdmF0aW9uQm9yZGVyQ29sb3IiOiIjNjY2IiwiYWN0aXZhdGlvbkJrZ0NvbG9yIjoiI2Y0ZjRmNCIsInNlcXVlbmNlTnVtYmVyQ29sb3IiOiJ3aGl0ZSIsInNlY3Rpb25Ca2dDb2xvciI6InJnYmEoMTAyLCAxMDIsIDI1NSwgMC40OSkiLCJhbHRTZWN0aW9uQmtnQ29sb3IiOiJ3aGl0ZSIsInNlY3Rpb25Ca2dDb2xvcjIiOiIjZmZmNDAwIiwidGFza0JvcmRlckNvbG9yIjoiIzUzNGZiYyIsInRhc2tCa2dDb2xvciI6IiM4YTkwZGQiLCJ0YXNrVGV4dExpZ2h0Q29sb3IiOiJ3aGl0ZSIsInRhc2tUZXh0Q29sb3IiOiJ3aGl0ZSIsInRhc2tUZXh0RGFya0NvbG9yIjoiYmxhY2siLCJ0YXNrVGV4dE91dHNpZGVDb2xvciI6ImJsYWNrIiwidGFza1RleHRDbGlja2FibGVDb2xvciI6IiMwMDMxNjMiLCJhY3RpdmVUYXNrQm9yZGVyQ29sb3IiOiIjNTM0ZmJjIiwiYWN0aXZlVGFza0JrZ0NvbG9yIjoiI2JmYzdmZiIsImdyaWRDb2xvciI6ImxpZ2h0Z3JleSIsImRvbmVUYXNrQmtnQ29sb3IiOiJsaWdodGdyZXkiLCJkb25lVGFza0JvcmRlckNvbG9yIjoiZ3JleSIsImNyaXRCb3JkZXJDb2xvciI6IiNmZjg4ODgiLCJjcml0QmtnQ29sb3IiOiJyZWQiLCJ0b2RheUxpbmVDb2xvciI6InJlZCIsImxhYmVsQ29sb3IiOiJibGFjayIsImVycm9yQmtnQ29sb3IiOiIjNTUyMjIyIiwiZXJyb3JUZXh0Q29sb3IiOiIjNTUyMjIyIiwiY2xhc3NUZXh0IjoiIzEzMTMwMCIsImZpbGxUeXBlMCI6IiNFQ0VDRkYiLCJmaWxsVHlwZTEiOiIjZmZmZmRlIiwiZmlsbFR5cGUyIjoiaHNsKDMwNCwgMTAwJSwgOTYuMjc0NTA5ODAzOSUpIiwiZmlsbFR5cGUzIjoiaHNsKDEyNCwgMTAwJSwgOTMuNTI5NDExNzY0NyUpIiwiZmlsbFR5cGU0IjoiaHNsKDE3NiwgMTAwJSwgOTYuMjc0NTA5ODAzOSUpIiwiZmlsbFR5cGU1IjoiaHNsKC00LCAxMDAlLCA5My41Mjk0MTE3NjQ3JSkiLCJmaWxsVHlwZTYiOiJoc2woOCwgMTAwJSwgOTYuMjc0NTA5ODAzOSUpIiwiZmlsbFR5cGU3IjoiaHNsKDE4OCwgMTAwJSwgOTMuNTI5NDExNzY0NyUpIn19fQ)

![](https://mermaid.ink/img/eyJjb2RlIjoic2VxdWVuY2VEaWFncmFtXG4gICAgcGFydGljaXBhbnQgQ1BVMVxuICAgIHBhcnRpY2lwYW50IE1FTTFcbiAgICBwYXJ0aWNpcGFudCBSTklDMVxuICAgIHBhcnRpY2lwYW50IFJOSUMyXG4gICAgcGFydGljaXBhbnQgTUVNMlxuICAgIHBhcnRpY2lwYW50IENQVTJcblxuXG5yZWN0IHJnYigwLDEwMCwgMCwgMC4xKVxuICAgIE5vdGUgb3ZlciBSTklDMSwgUk5JQzI6IFNFTkQgLyBSRUNFSVZFXG4gICAgQ1BVMSAtLT4-IFJOSUMxOiBuZXcgU2VuZFJlcXVlc3QoU1IpXG4gICAgUk5JQzEgLS0-PiArTUVNMTogRE1BXG4gICAgTUVNMSAtLT4-IC1STklDMTogXG4gICAgUk5JQzEgLT4-IFJOSUMyOiBSRE1BIERhdGEgUGFja2FnZVxuICAgIFJOSUMyIC0tPj4gK01FTTI6IERNQVxuICAgIE1FTTIgLS0-PiAtUk5JQzI6IFxuICAgIFJOSUMyIC0tPj4gQ1BVMjogQ29tcGxldGlvbkV2ZW50XG4gICAgUk5JQzIgLT4-IFJOSUMxOiBSRE1BIEFDS1xuICAgIFJOSUMxIC0tPj4gQ1BVMTogQ29tcGxldGlvbkV2ZW50XG5lbmRcbnJlY3QgcmdiKDI1NSwwLCAyNTUsIDAuMSlcbiAgICBOb3RlIG92ZXIgUk5JQzEsIFJOSUMyOiBSRUFELCBSRUxJQUJMRSBDSEFOTkVMIChSQylcbiAgICBDUFUxIC0tPj4gUk5JQzE6IG5ldyBTZW5kUmVxdWVzdChTUilcbiAgICBSTklDMSAtPj4gUk5JQzI6IFJETUEgRGF0YSBQYWNrYWdlXG4gICAgUk5JQzIgLS0-PiArTUVNMjogRE1BXG4gICAgTUVNMiAtLT4-IC1STklDMjogXG4gICAgUk5JQzIgLT4-IFJOSUMxOiBSRE1BIEFDS1xuICAgIFJOSUMxIC0tPj4gQ1BVMTogQ29tcGxldGlvbkV2ZW50IChDRSlcbmVuZFxuXG5yZWN0IHJnYigwLDAsIDI1NSwgMC4xKVxuICAgIE5vdGUgb3ZlciBSTklDMSwgUk5JQzI6IFdSSVRFLCBSQywgU0lHTkFMRURcbiAgICBDUFUxIC0tPj4gUk5JQzE6IG5ldyBTZW5kUmVxdWVzdChTUilcbiAgICBSTklDMSAtLT4-ICtNRU0xOiBETUFcbiAgICBNRU0xIC0tPj4gLVJOSUMxOiBcbiAgICBSTklDMSAtPj4gUk5JQzI6IFJETUEgRGF0YSBQYWNrYWdlXG4gICAgUk5JQzIgLS0-PiBNRU0yOiBETUFcbiAgICBSTklDMiAtPj4gUk5JQzE6IFJETUEgQUNLXG4gICAgUk5JQzEgLS0-PiBDUFUxOiBDb21wbGV0aW9uRXZlbnQgKENFKVxuZW5kXG5cbnJlY3QgcmdiKDAsMCwgMjU1LCAwLjEpXG4gICAgTm90ZSBvdmVyIFJOSUMxLCBSTklDMjogV1JJVEUsIFJDLCBVTlNJR05BTEVEXG4gICAgQ1BVMSAtLT4-IFJOSUMxOiBuZXcgU2VuZFJlcXVlc3QoU1IpXG4gICAgUk5JQzEgLS0-PiArTUVNMTogRE1BXG4gICAgTUVNMSAtLT4-IC1STklDMTogXG4gICAgUk5JQzEgLT4-IFJOSUMyOiBSRE1BIERhdGEgUGFja2FnZVxuICAgIFJOSUMyIC0tPj4gTUVNMjogRE1BXG4gICAgUk5JQzIgLT4-IFJOSUMxOiBSRE1BIEFDS1xuZW5kXG5cblxucmVjdCByZ2IoMCwyNTUsIDE1NSwgMC4xKVxuICAgIE5vdGUgb3ZlciBSTklDMSwgUk5JQzI6IFdSSVRFLCBJTkxJTkVELCBVQywgVU5TSUdOQUxFRFxuICAgIENQVTEgLS0-PiBSTklDMTogbmV3IFNlbmRSZXF1ZXN0KFNSKVxuICAgIFJOSUMxIC0-PiBSTklDMjogUkRNQSBEYXRhIFBhY2thZ2VcbiAgICBSTklDMiAtLT4-IE1FTTI6IERNQVxuZW5kXG5cbnJlY3QgcmdiKDAsMTAwLCAxNTUsIDAuMSlcbiAgICBOb3RlIG92ZXIgUk5JQzEsIFJOSUMyOiBXUklURSBXSVRIIElNTSwgSU5MSU5FRCwgUkMsIFNJR05BTEVEXG4gICAgQ1BVMSAtLT4-IFJOSUMxOiBuZXcgU2VuZFJlcXVlc3QoU1IpXG4gICAgUk5JQzEgLT4-IFJOSUMyOiBSRE1BIERhdGEgUGFja2FnZVxuICAgIFJOSUMyIC0tPj4gTUVNMjogRE1BXG4gICAgUk5JQzIgLS0-PiBDUFUyOiBJbW1lZGlhdGUgdmFsdWVcbiAgICBSTklDMiAtPj4gUk5JQzE6IFJETUEgQUNLXG5lbmRcbiIsIm1lcm1haWQiOnsidGhlbWUiOiJkZWZhdWx0IiwidGhlbWVWYXJpYWJsZXMiOnsiYmFja2dyb3VuZCI6IndoaXRlIiwicHJpbWFyeUNvbG9yIjoiI0VDRUNGRiIsInNlY29uZGFyeUNvbG9yIjoiI2ZmZmZkZSIsInRlcnRpYXJ5Q29sb3IiOiJoc2woODAsIDEwMCUsIDk2LjI3NDUwOTgwMzklKSIsInByaW1hcnlCb3JkZXJDb2xvciI6ImhzbCgyNDAsIDYwJSwgODYuMjc0NTA5ODAzOSUpIiwic2Vjb25kYXJ5Qm9yZGVyQ29sb3IiOiJoc2woNjAsIDYwJSwgODMuNTI5NDExNzY0NyUpIiwidGVydGlhcnlCb3JkZXJDb2xvciI6ImhzbCg4MCwgNjAlLCA4Ni4yNzQ1MDk4MDM5JSkiLCJwcmltYXJ5VGV4dENvbG9yIjoiIzEzMTMwMCIsInNlY29uZGFyeVRleHRDb2xvciI6IiMwMDAwMjEiLCJ0ZXJ0aWFyeVRleHRDb2xvciI6InJnYig5LjUwMDAwMDAwMDEsIDkuNTAwMDAwMDAwMSwgOS41MDAwMDAwMDAxKSIsImxpbmVDb2xvciI6IiMzMzMzMzMiLCJ0ZXh0Q29sb3IiOiIjMzMzIiwibWFpbkJrZyI6IiNFQ0VDRkYiLCJzZWNvbmRCa2ciOiIjZmZmZmRlIiwiYm9yZGVyMSI6IiM5MzcwREIiLCJib3JkZXIyIjoiI2FhYWEzMyIsImFycm93aGVhZENvbG9yIjoiIzMzMzMzMyIsImZvbnRGYW1pbHkiOiJcInRyZWJ1Y2hldCBtc1wiLCB2ZXJkYW5hLCBhcmlhbCIsImZvbnRTaXplIjoiMTZweCIsImxhYmVsQmFja2dyb3VuZCI6IiNlOGU4ZTgiLCJub2RlQmtnIjoiI0VDRUNGRiIsIm5vZGVCb3JkZXIiOiIjOTM3MERCIiwiY2x1c3RlckJrZyI6IiNmZmZmZGUiLCJjbHVzdGVyQm9yZGVyIjoiI2FhYWEzMyIsImRlZmF1bHRMaW5rQ29sb3IiOiIjMzMzMzMzIiwidGl0bGVDb2xvciI6IiMzMzMiLCJlZGdlTGFiZWxCYWNrZ3JvdW5kIjoiI2U4ZThlOCIsImFjdG9yQm9yZGVyIjoiaHNsKDI1OS42MjYxNjgyMjQzLCA1OS43NzY1MzYzMTI4JSwgODcuOTAxOTYwNzg0MyUpIiwiYWN0b3JCa2ciOiIjRUNFQ0ZGIiwiYWN0b3JUZXh0Q29sb3IiOiJibGFjayIsImFjdG9yTGluZUNvbG9yIjoiZ3JleSIsInNpZ25hbENvbG9yIjoiIzMzMyIsInNpZ25hbFRleHRDb2xvciI6IiMzMzMiLCJsYWJlbEJveEJrZ0NvbG9yIjoiI0VDRUNGRiIsImxhYmVsQm94Qm9yZGVyQ29sb3IiOiJoc2woMjU5LjYyNjE2ODIyNDMsIDU5Ljc3NjUzNjMxMjglLCA4Ny45MDE5NjA3ODQzJSkiLCJsYWJlbFRleHRDb2xvciI6ImJsYWNrIiwibG9vcFRleHRDb2xvciI6ImJsYWNrIiwibm90ZUJvcmRlckNvbG9yIjoiI2FhYWEzMyIsIm5vdGVCa2dDb2xvciI6IiNmZmY1YWQiLCJub3RlVGV4dENvbG9yIjoiYmxhY2siLCJhY3RpdmF0aW9uQm9yZGVyQ29sb3IiOiIjNjY2IiwiYWN0aXZhdGlvbkJrZ0NvbG9yIjoiI2Y0ZjRmNCIsInNlcXVlbmNlTnVtYmVyQ29sb3IiOiJ3aGl0ZSIsInNlY3Rpb25Ca2dDb2xvciI6InJnYmEoMTAyLCAxMDIsIDI1NSwgMC40OSkiLCJhbHRTZWN0aW9uQmtnQ29sb3IiOiJ3aGl0ZSIsInNlY3Rpb25Ca2dDb2xvcjIiOiIjZmZmNDAwIiwidGFza0JvcmRlckNvbG9yIjoiIzUzNGZiYyIsInRhc2tCa2dDb2xvciI6IiM4YTkwZGQiLCJ0YXNrVGV4dExpZ2h0Q29sb3IiOiJ3aGl0ZSIsInRhc2tUZXh0Q29sb3IiOiJ3aGl0ZSIsInRhc2tUZXh0RGFya0NvbG9yIjoiYmxhY2siLCJ0YXNrVGV4dE91dHNpZGVDb2xvciI6ImJsYWNrIiwidGFza1RleHRDbGlja2FibGVDb2xvciI6IiMwMDMxNjMiLCJhY3RpdmVUYXNrQm9yZGVyQ29sb3IiOiIjNTM0ZmJjIiwiYWN0aXZlVGFza0JrZ0NvbG9yIjoiI2JmYzdmZiIsImdyaWRDb2xvciI6ImxpZ2h0Z3JleSIsImRvbmVUYXNrQmtnQ29sb3IiOiJsaWdodGdyZXkiLCJkb25lVGFza0JvcmRlckNvbG9yIjoiZ3JleSIsImNyaXRCb3JkZXJDb2xvciI6IiNmZjg4ODgiLCJjcml0QmtnQ29sb3IiOiJyZWQiLCJ0b2RheUxpbmVDb2xvciI6InJlZCIsImxhYmVsQ29sb3IiOiJibGFjayIsImVycm9yQmtnQ29sb3IiOiIjNTUyMjIyIiwiZXJyb3JUZXh0Q29sb3IiOiIjNTUyMjIyIiwiY2xhc3NUZXh0IjoiIzEzMTMwMCIsImZpbGxUeXBlMCI6IiNFQ0VDRkYiLCJmaWxsVHlwZTEiOiIjZmZmZmRlIiwiZmlsbFR5cGUyIjoiaHNsKDMwNCwgMTAwJSwgOTYuMjc0NTA5ODAzOSUpIiwiZmlsbFR5cGUzIjoiaHNsKDEyNCwgMTAwJSwgOTMuNTI5NDExNzY0NyUpIiwiZmlsbFR5cGU0IjoiaHNsKDE3NiwgMTAwJSwgOTYuMjc0NTA5ODAzOSUpIiwiZmlsbFR5cGU1IjoiaHNsKC00LCAxMDAlLCA5My41Mjk0MTE3NjQ3JSkiLCJmaWxsVHlwZTYiOiJoc2woOCwgMTAwJSwgOTYuMjc0NTA5ODAzOSUpIiwiZmlsbFR5cGU3IjoiaHNsKDE4OCwgMTAwJSwgOTMuNTI5NDExNzY0NyUpIn19LCJ1cGRhdGVFZGl0b3IiOmZhbHNlfQ)

## Messages sent

V1

```
             step 1        step 2               step 3
leader    =  g * p    +    (g-1)+(p-1)    +     (p-1)*(g-1)+g*p-1
follower  =  g * p    +    0              +     g*p-1
```

+ Step 1: 1 process sends messages to all involved processes (g*p)
+ Step 2: leader process send timestamp to (g-1) leaders, and (p-1) followers of its group. Follower processes don't do anything.
+ Step 3: leader process propagates timestamps of other leaders to its follower (g-1) * (p-1) and send acks to all other processes (g * p-1). Followers only send acks to all other processes (g * p - 1).
With g=2, p=3, a leader needs to perform 17 writes, a follower does 11 writes


> In implementation, a leader propagates timestamp of another leader as soon as it got the timestamp in the buffer. And it does that separately for each other leaders, as those timestamps may not come at the same time. That's why it's (g-1)*(p-1) in my calculation. I can change this to let the leader wait for all timestamps to be available, and propagate them at once, so we can have (p-1).

> I consider leader also one process in the group, plays role of follower. That's why it also send the acks to other processes. If we separate the role of leader and follower, it doesn't need to send those acks. I've tried this way too, It could also boost up the throughput to 60k msg/p.


V2

```
              step 1        step 2             step 3
proposer  =   g * p
leader    =   0       +     (g-1)+(p-1)   +     (p-1)
follower  =   0       +     0             +     g*p-1
```

+ Step 1: the proposer sends its value to all processes, g*p messages in total
+ Step 2: the leader of each group sends its timestamp to: (a) its followers and (b) all other leaders, (p-1)+(g-1)
Sending to the followers is Phase 2a of Paxos; sending to all other leaders is for them to advance their local clocks, and not propose anything with a smaller timestamp
+ Step 3: leader wait for all timestamps to be available, and propagate them at once, that makes (p-1) writes.
Followers only send acks to all other processes (g*p-1).


## Leader Election

### Leader selection

Leader election is implemented using Apache ZooKeeper, a co-ordination service.

![](https://pocket-image-cache.com//filters:no_upscale()/http%3A%2F%2Fwww.allprogrammingtutorials.com%2Fimages%2Fleader-election-algorithm.png)

To summarize, each of the node will create a ephemeral and sequential znode at start up under "/election" persistent znode. Since znode created by process is sequential, ZooKeeper will add a unique sequence number to its name. Once this is done, process will fetch all the child znodes of "/election" znode and look for child znode having smallest sequence number. If the smallest sequence number child znode is same as znode created by this process, then current process will declare itself leader by printing the message "I am new leader".

However, if the process znode does not have smallest sequence number, it will set a watch on the znode having sequence number just smaller than its process znode. E.g. if current process znode is "p_0000234" and other process znodes are "p_0000123", "p_0000129", "p_0000223", "p_0000235", "p_0000245" then current process znode will be setting the watch on znode with path "p_0000223".

As soon as the watched ephemeral znode is removed by ZooKeeper due to process being shutdown, current process gets a watchevent notification. Thereafter, current process again fetches the child znodes of "/election" and repeat the steps of checking whether it is leader.

http://www.allprogrammingtutorials.com/tutorials/leader-election-using-apache-zookeeper.php

### Leader election & failure handling

- The selected leader inits only one round of Phase 1 paxos, by sending 1A message with its ballot number.
- Leader needs to include its ballot number when write its timestamp.
- Follower only ack timestamps that have ballot number >= the largest ballot number that it knows
- When a leader fails, new leader is selected => increase its ballot number => send 1A message

- **How could a process know the leader of another group???**
  => When leader sends 1A, it should includes all processes.
    => Followers sends 1B, also for all processes.

So these value will be includes in the write of leader:
- ballot number => follower will not accept ts with lower ballott
- timestamp  => the value to be decided => not related to paxos
- write counter => instance number

Message structure need to be updated

```
╔════════╦════════╦════════════════╦═════════════╦═════════════╦═══════════════════════════════════════════════════════════════════════╦════════════╦════════════════════════════════════════════════╦═══════════════════════════════════════════════╗
║ id=962 ║ len=6  ║ gCount=2       ║ AAA         ║ 0    │ 1    ║ 140665081851888 │ 140501671660992 │ 139704552803616 │ 139799176205904 ║     68     ║   1   |   4   |   0    ║   0   |   4   |   0   ║     0     │     0     │     0     │     0     ║
╠════════╬════════╬════════════════╬═════════════╬═════════════╬═══════════════════════════════════════════════════════════════════════╬════════════╬════════════════════════════════════════════════╬═══════════════════════════════════════════════╣
║   4    ║   4    ║     2          ║    6        ║    2 * 2    ║                               8 * 2 * 2                               ║      4     ║                     (4+4+4) * 2                ║                  2 * r * n                    ║
╠════════╬════════╬════════════════╬═════════════╬═════════════╬═══════════════════════════════════════════════════════════════════════╬════════════╬════════════════════════════════════════════════╬═══════════════════════════════════════════════╣
║  id    ║ length ║ groupCount (n) ║ message (m) ║ g[0] │ g[1] ║ offset[0][0]    │ offset[0][1]    │ offset[1][0]    │ offset[1][1]    ║ lengthCheck║ ts[0] | cw[0] | bl[0] ║ ts[1] | cw[1] | bl[1]  ║ ack[0][0] │ ack[0][1] │ ack[1][0] │ ack[1][1] ║
╚════════╩════════╩════════════════╩═════════════╩═════════════╩═══════════════════════════════════════════════════════════════════════╩═════════════════════════════════════════════════════════════╩═══════════════════════════════════════════════╝
```





Use RDMA Write with immediate, which will consume the Receive Request in the receiver side and generate a Work Completion.
=> need to post recv request on receiver side before receiving write



### Leader syncing

client sends synced request => wait for reply => no holes

otherwise => holes in the shared buffer.




Single group
  - Leader process writes 2A on 1 of 4 followers then fails
    - 1 of 4 followers writes back 2B
    - All processes (new leader + 3 followers) receives one 2B 
    - New leader increases ballot number, WRITE-WITH-IMM new 1A
    - Followers write 1B for new msg
  - Leader process writes 2A on 3 of 4 followers then fails
    - 3 of 4 processes write back 2B
    - 3 of 4 processes receives 3 2B => deliver msg 
    - if leader receives 2A => deliver msg
    - if leader does not receive 2A, but receive 3 2B  => TODO: 