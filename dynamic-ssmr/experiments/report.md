###System Config:

* SSMR:

| Node # |           Role           |
|--------|--------------------------|
| 21-29  | Muilticast Agent         |
| 35,36  | Replica 1,2; Partition 1 |
| 37.38  | Replica 1,2; Partition 2 |
| 39     | Monitor                  |
| 65-88  | Clients                  |

* DSSMR

| Node # |           Role           |
|--------|--------------------------|
| 21-32  | Muilticast Agent         |
| 35,36  | Replica 1,2; Partition 1 |
| 37.38  | Replica 1,2; Partition 2 |
| 39,40  | Oracle                   |
| 41     | Monitor                  |
| 65-88  | Clients                  |


###Test result

**Single-partition command**

| client nodes | thread per client | simulated client |    ssmr   |  dssmr   |        ssmr       |    dssmr    |
|--------------|-------------------|------------------|-----------|----------|-------------------|-------------|
|              |                   |                  | delay(ms) | delay    | throughtput (cps) | throughtput |
|            1 |                 1 |                1 | **5**     | **4.8**  | 195               | 208         |
|            1 |                10 |               10 | **5.2**   | **5.6**  | 1883              | 1781        |
|            1 |                15 |               15 | **5.3**   | **5.2**  | 2778              | 2699        |
|           10 |                 5 |               50 | **6.3**   | **7.3**  | 7881              | 6800        |
|           10 |                10 |              100 | **8.1**   | **11.4** | 12146             | 8653        |
|           20 |                10 |              200 | **13**    | **27**   | 15291             | 7224        |


**Multi-partition command**

| client nodes | thread per client | simulated client |    ssmr   |   dssmr   |        ssmr       |    dssmr    |
|--------------|-------------------|------------------|-----------|-----------|-------------------|-------------|
|              |                   |                  | delay(ms) | delay     | throughtput (cps) | throughtput |
|            1 |                 1 |                1 | **5.7**   | **10.4**  | 172               | 95          |
|            1 |                 3 |                3 | **6.7**   | **11.3**  | 440               | 264         |
|            5 |                 1 |                5 | **12**    | **10.8**  | 459               | 461         |
|            5 |                 2 |               10 | **24**    | **11.79** | 414               | 851         |
|            5 |                 3 |               15 | **38**    | **13**    | 394               | 1151        |
|           10 |                 1 |               10 | **21**    | **11.9**  | 463               | 840         |
|           10 |                 2 |               20 | **NA**    | **14.5**  | NA                | 1379        |
|           20 |                 1 |               20 | **NA**    | **14.4**  | NA                | 1392        |
|           20 |                 2 |               40 | **NA**    | **23**    | NA                | 1722        |
