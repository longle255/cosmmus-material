## Overral:

ORACLE (Rev.A,B,C,D,E)

DynaStar implements the oracle as a regular RSM: replicated in a set of machines, to tolerate failures. So the oracle tolerates failures like any other partition. For performance, clients cache oracle entries. Both replication and caching have been implemented and performance results reflect them.

The oracle only needs requests that change the workload graph. These are sent as hints by the partitions. When the changes exceed a threshold, the Oracle repartitions the graph.

In the experiments, the oracle had the same resources as every other partition: 2 replicas and 3 acceptors (in total five nodes per partition).


LIVENESS (Rev.A

We assume an asynchronous system augmented with atomic multicast (consensus). How atomic multicast is implemented is not important for DynaStar.

FLITTER & NEST (Rev.A,C

These old names of DynaStar. Sorry.


METIS (Rev. A, C

METIS does not necessarily produce the best possible partitioning of the workload graph (sub-optimal partitioning).

DynaStar doesn't depend on any particular graph partitiiner.


EXPERIMENTS (Rev.A, C

We measured throughput and latency under peak throughput.

Our social network is synthetic, but the mimics the structure of real social networks (power-law distribution of links).
The size of the network only matters for the oracle, whose performance we assess independently (see Figs. 6 and 7).

RELATED WORK

We will cite Clay, which is related to DynaStar. (Rev. B)




Review A

> -In Algorithm 1, how does the "while reply = retry" line accomplish the "eventually fall back to S-SMR"? Is the comment not trying to explain the pseudocode, but rather to augment it? That's a bit weird. You should clarify.

For conciseness, the algorithm omits some details that are handled in the text only.

> -In IV.D., why is Cj<Zk<Ci a contradiction for the other two cases? Wouldn't Cj<Ci be the contradiction? Why does Zk have to be between Cj and Ci?

Review B

> Figure 4 shows that the scalability of the system basically stops at 4 partitions. Is this a problem of the application? Aren’t there cases where DynaStar can scale more?

Figure 4 shows the ideal number of partition for a particular workload. It was meant to show that for a certain workload, there is an optimal partition configuration for it. DynaStar could scale with more partition, but with less benefit than the optimal configuration.

>I would expect that in some cases there can be a huge performance degradation while data movement is ongoing. I was surprised to see that the degradation is relatively minor in figure 5a. A little more discussion on this point would be interesting.

DynaStar moves a small numner of objects at a time and objects are small (a few kilobytes).

> In Section VI.B, the workload is characterized in terms of the edge cut. This is confusing. Which edge cut is the text referring to? The one produced by METIS? 

yes, edges across partitions

Review D

> ... Fig. 2 is not referred to anywhere in the text. I do not understand it and would appreciate an explanation.

We will add a reference to Fig.2.


> How many commands were executed? Were the same social graphs and same commands used for all tools? How much reorganisation was done by DS-SMR versus how many partitioning processes were needed for DynaStar? The evaluation is very fuzzy.

Each experiment was run for about 2.5 minutes. We use the same social graph for each technique. Fig.1 shows number of moves for DS-SMR and DynaStar.

Review E

> --- I missed several things in the evaluation. The major one is impact of oracle information caching at the clients on the accuracy of such information under high dynamics. 

Effects of cache misses can be seen in the experiments depicted in Fig.5.

