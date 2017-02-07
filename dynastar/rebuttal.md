## Overral:

ORACLE (Rev.A,B,C

DynaStar implements the oracle as a regular RSM: replicated in a set of machines, to tolerate failures. So the oracle tolerates failures like any other partition. For performance, clients cache oracle entries. Both replication and caching have been implemented and performance results reflect them.

Oracle monitors requests that change the workload graph. When the change exceeds a threshold, Oracle the triggers repartitioning process. P

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







Executing multi-partition commands is actually more complicated and non-trivial, partition must exchanging data & signal, which basically introduce big overhead. For example, imagine a command that needs objects A, B, and C, each one in a different partition, P1, P2 e P3. With DynaStar, if we decide to execute the command at P1, then P2 and P3 need to send B and C to P1. Thus, DynaStar requires O(n), where n is the number of partitions involved in the command. Now consider the S-SMR model: P1 has to move A to P2 and P3, P2 has to move B to P1 and P3, …. This is O(n^2)! Besides this, the three partitions will execute the command, against a single one in DynaStar. So, O(n) versus O(1)!

In the experiment, oracle has same configuration with partitions: each has 2 replicas and 3 acceptors (in total five nodes per partition), with HP SE1102 nodes, 2x 2.5 GHz Intel Xeon L5420 processorsm, 8 GB of main memory.

### Review #136D

> **Summary**
>
> This paper improves on reference [9]: L. L. Hoang, C. E. Bezerra, and F. Pedone, “Dynamic scalable state machine replication,” in DSN, 2016.

> The authors observe that in [9] the dynamic state machine replication does not work so well under workloads with weak locality. Such workloads lead to a workload graph that cannot easily be split by graph partitioning algorithms. In a workload graph the nodes are the state variables and the edges are the commands accessing those variables. Workloads with weak locality have the same state variable in several nodes and need to frequently rearrange the graph.

> The authors state that it is more efficient to create the workload graph on-the-fly and use graph partitioning techniques to efficiently relocate application state on-demand rather than keep a workflow graph that needs frequent reorganisation. The results show that this is true.


> **Strengths**
>
> + scalable dynamic state machine replication is useful
> + results show large improvements

> **Weaknesses**
>
> - the evaluation is not clear. Experiments are not well explained
> - the reasoning is sometimes obscure and I am not convinced of using a static approach fast instead of coming up with a real new solution
> - costs of the approach are not quantified
> - the writing is sloppy, definitions are missing, the style is narrative and not technical


**Detail**

> This paper improves on reference [9]: L. L. Hoang, C. E. Bezerra, and F. Pedone, “Dynamic scalable state machine replication,” in DSN, 2016.

> The authors observe that in [9] the dynamic state machine replication does not work so well under workloads with weak locality. Such workloads lead to a workload graph that cannot easily be split by graph partitioning algorithms. In a workload graph the nodes are the state variables and the edges are the commands accessing those variables. Workloads with weak locality have the same state variable in several nodes and need to frequently rearrange the graph.

> The authors state that it is more efficient to create the workload graph on-the-fly and use graph partitioning techniques to efficiently relocate application state on-demand rather than keep a workflow graph that needs frequent reorganisation. The results show that this is true.

> I would have drawn a different conclusion: perhaps a workload graph is not an appropriate tool for a dynamic SMR algorithm. It seems to me that the partitioning is at too fine a granularity to be flexible enough. It seems that checking for each command whether the state variables are present and otherwise issuing a new partitioning process is a huge effort. In mobile computing code partitioning is used as well, but at much coarser level. Maybe that should be done here too.

...

> I am a bit confused about the quality criteria. In the section 'Correctness' the authors reason about consistency. Of course consistency is important, but it should be argued why nothing else need be considered. If it is so.

...

> The paper has a good flow, but is not very well organised. It is unusual to see results in the introduction and a small running example would help very much.  Also Fig. 2 is not referred to anywhere in the text. I do not understand it and would appreciate an explanation.

... *should add some text for Figure 2*

> The proof in Sec. IV.D uses timing concepts that would need a 'happened-before' relation, but I cannot find this in the paper. The reasoning about timing seems inadequate for a distributed system.

...

> The description of the experiments is unclear. How many commands were executed? Were the same social graphs and same commands used for all tools? How much reorganisation was done by DS-SMR versus how many partitioning processes were needed for DynaStar? The evaluation is very fuzzy.

... 

> It is interesting to note that DS-SMR has the same behaviour (and almost identical results) for an increasing ratio of edge-cuts. Apparently it makes no difference how many edges are cut. This holds for both throughput and latency (which are of course related).

...*is he talking about ds-smr?*

> Even though this paper leaves many questions open it is interesting. The question how to dynamically reorganise partitions is interesting. This is one suggestion and interesting as such. However, the paper should much more rigorously explain, what is being done!

... thank you

>Some minor comments:
>
> - DynaStar is also the name of a ski producing company, so I am not sure whether it is a good choice.
> - p. 2: 'Flitter' and 'Nest' are only introduced much later?
> - p. 12: Reference [9] is not by Long et al.

### Review #136E

> **Summary**
>
> The paper introduces a centralized oracle that helps in dynamic state-machine replication partitioning. It shows how this approach helps boost performance compared to state-of-the-art decentralized approach.


> **Strengths**
>
> - The paper is well written.
> - It tackles an important topic.


> **Weaknesses**
>
> - The idea that the paper brings is a  bit disappointing in the DSN context. The authors introduce a single point of failure to boost performance. 
> - Overall, the paper seems incremental improvement compared to S-SMR and DS-SMR
> - The method puts oracle in the critical path which seems like a bad idea even performance-wise. Authors do get around this by putting classical caching at the clients but do not really explain the tradeoffs involved.


**Detail**

> --- Why not use a dedicated non partitioned state machine replication for oracle? Centralized oracle is really killing this paper for me. 

It is!!!

> --- I missed several things in the evaluation. The major one is impact of oracle information caching at the clients on the accuracy of such information under high dynamics. 

cache hit, you meant?

> --- What are the characteristics of the machine used for the oracle? The testbed described does not describe which particular hardware was used for oracle. 

we did, on top of exepriment section. 

> --- Number of clients used in experiments seems very arbitrary. The evaluation would benefit from increasing number of clients until the point where performance starts to break. For instance, in Figure 7, how many clients one needs to run to saturate the oracle so it actually becomes the bottleneck? This is clearly related to the above question of the hardware used for the oracle.

We increase number of client gradually, until reach the peak throughput. That's the number reported in the Figure 3. Correspondingly, Figure 7 depicts the CPU of the oracle in the test of 5% edge-cut, on 2,4 and 8 partitions
