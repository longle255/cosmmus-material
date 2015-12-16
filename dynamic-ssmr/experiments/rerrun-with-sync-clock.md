# Re-run test with synchronized clocks

### Setup
	- Clocks are synced in 3 sec intervals. 
	- ntp server: node249
	- Node 20-88
	- Command: 100% Post


### DSSMR

| Clients | Partitions | Report Latency | SyncedClock Latency | Report Throughput | SyncedClock throughput |
|---------|------------|----------------|---------------------|-------------------|------------------------|
| **200** |          2 |        8570062 |             7153939 |             23295 |                  27889 |
| 300     |          2 |        9918642 |             9690371 |             30195 |                  30901 |
| **300** |          4 |        9030615 |             9067899 |             33142 |                  33008 |
| 400     |          4 |       11345397 |            11450564 |             35188 |                  34858 |
| **400** |          8 |        7513582 |             8013632 |             52758 |                  49528 |
| 500     |          8 |        9145008 |             8794577 |             54249 |                  56275 |


### SSMR 

| Clients | Partitions | Report Latency | SyncedClock Latency | Report Throughput | SyncedClock throughput |
|---------|------------|----------------|---------------------|-------------------|------------------------|
| 10      |          2 |        4187982 |             4173726 |              2383 |                   2390 |
| **15**  |          2 |        5191166 |             5192401 |              2884 |                   2882 |
| 10      |          4 |        6458614 |             6514249 |              1544 |                   1531 |
| **15**  |          4 |        7903725 |             7937032 |              1894 |                   1886 |