# TODO

### Next steps

- [ ] Implementing DELETE command
- [ ] Fallback to SSMR execution when clients reach a number of RETRY	
- [ ] Re-run some testcases with clock synchronized. *already got the sudoer permission from Paulo*
- [ ] Benchmarking DSSMR with TPC-C
	+ Finding/Creating TPC-C implementation works with in memory data.
	+ Comparing with Schism
- [ ] System monitors graph's connection/behavior, performs auto optimization for objects partitioning
- [ ] Running test on system with partitions geolocation distributed 
- [ ] Switch to Genuine Atomic Multicast if possible. *talk to Paulo*
- [ ] Experiments with more than 8 partitions, by collocating multiple partitions in the same physical server
- TBD...


### Known issues:

- [ ] Issue of concurrency sometimes occurs when accessing client's proxy cache when number of threads per client exceed some limit (38 as observed so far)
- [ ] incorrect timestamps on monitor logs of partition servers and client


### Low priority

- [ ] Refactor monitoring at state machine proxy to be more generic. Should be able to monitor number of VALID/INVALID MOVE
