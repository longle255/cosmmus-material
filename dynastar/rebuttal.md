THE MISUNDERSTOOD ORACLE (Rev.A,B,C,D,E)

We realize now that our descriptions were unclear, and we will revise. The oracle is not a centralized, single point of failure. DynaStar implements the oracle as a regular RSM: replicated in a set of machines to tolerate failures, like any other partition. For performance, clients cache oracle entries. Both replication and caching are implemented and used in the experiments.

The oracle only needs requests that change the workload graph. These are sent as hints by the partitions. When the changes exceed a threshold, the Oracle repartitions the graph.

In the experiments, the oracle had the same resources as every other partition: 2 replicas and 3 acceptors (in total five nodes per partition).

LIVENESS (Rev.A)

We assume an asynchronous system augmented with atomic multicast (consensus). How atomic multicast is implemented is not important for DynaStar.

FLITTER & NEST (Rev.A,C)

These are old names of DynaStar. Sorry.

METIS (Rev.A,C)

METIS does not necessarily produce the best possible partitioning of the workload graph (sub-optimal partitioning). DynaStar doesn't depend on any particular graph partitioner. We chose METIS because it produces reasonable partitioning efficiently.

EXPERIMENTS (Rev.A,C)

We measured throughput and latency under peak throughput.

Our social network is synthetic, but it mimics the structure of real social networks (power-law distribution of links). The size of the network only matters for the oracle, whose performance we assess independently (see Figs. 6 and 7).


REVIEW SPECIFIC COMMENTS

Review A

>In Algorithm 1, how does the "while reply = retry" ...
For conciseness, the algorithm omits some details that are handled in the text only.

Review B

We will cite Clay, which is related to DynaStar.

Figure 4 shows the ideal number of partitions for a particular workload. It was meant to show that for a certain workload, there is an optimal partition configuration. DynaStar can scale with more partitions, if the workload allows it.

>… I was surprised to see that the degradation is relatively minor in figure 5a. A little more discussion on this point would be interesting.

DynaStar moves a small number of objects at a time and objects are small (a few kilobytes).

>In Section VI.B, the workload is characterized in terms of the edge cut. Which edge cut is the text referring to? The one produced by METIS?

yes, edges across partitions

Review D

>How many commands were executed? Were the same social graphs and same commands used for all tools? How much reorganisation was done by DS-SMR versus how many partitioning processes were needed for DynaStar? The evaluation is very fuzzy.

Each experiment was run for about 2.5 minutes. We use the same social graph for each technique. Fig.1 shows number of moves for DS-SMR and DynaStar.

Review E

>I missed several things in the evaluation. The major one is impact of oracle information caching at the clients on the accuracy of such information under high dynamics.

Effects of cache misses can be seen in the experiments depicted in Fig.5.
