## Overral:

As stated in the paper, DynaStar implements the oracle as a regular RSM, which is replicated in a set of machines, to tolerate failures.

Oracle monitors every requests, and keeps track the ones that change workload graph. When the change exceeds a threshold, Oracle triggers repartitioning process. Partitioner is a pluggable component. The partitioner does not necessarily produce the best possible partitioning of the workload graph, we choose Metis since it offers a good compromise between performance and partitioning quality

Executing multi-partition commands is actually more complicated and non-trivial, partition must exchanging data & signal, which basically introduce big overhead. For example, imagine a command that needs objects A, B, and C, each one in a different partition, P1, P2 e P3. With DynaStar, if we decide to execute the command at P1, then P2 and P3 need to send B and C to P1. Thus, DynaStar requires O(n), where n is the number of partitions involved in the command. Now consider the S-SMR model: P1 has to move A to P2 and P3, P2 has to move B to P1 and P3, …. This is O(n^2)! Besides this, the three partitions will execute the command, against a single one in DynaStar. So, O(n) versus O(1)!

In the experiment, oracle has same configuration with partitions: each has 2 replicas and 3 acceptors (in total five nodes per partition), with HP SE1102 nodes, 2x 2.5 GHz Intel Xeon L5420 processorsm, 8 GB of main memory.



### Review #136A

> **Summary**
>
> This paper presents DynaStar, a new approach for dynamically partitioning the state in a "sharded" replicated state machine. Contrary to previous approaches, DynaStar uses a centralized oracle, which applies an optimized partitioner on the dynamically created workload graph. DynaStar outperforms DS-SMR, the previous best dynamic partitioning scheme when locality is weak. In the case of strong locality both systems achieve the same throughput eventually, but DynaStar converges to that throughput faster than DS-SMR.

> **Strengths**
>
>  - The paper's idea is simple enough that it could be incorporated in real-world implementations of scalable replicated services.
>  - The writing is quite clear, in terms of both clarity and the use of English.
>  - In the weak locality case, DynaStar has a clear advantage over DS-SMR.


> **Weaknesses**
>
> - The idea is simple enough that it borders on incremental. 

> - Most of the performance benefit comes when there's weak locality. In the presence of strong locality, it's unclear what those extra 60 seconds of early convergence really buy.
>
> - The papers makes some weird design decisions and assumptions that don't match with their claims very well (more on that below).


**Detail**

> First, I have a high-level comment. Throughout your design, you seem to make the assumption that a command must only be executed at a single partition, and if the state is split, some of it must be moved. While that is a noble goal, I imagine that some times---particularly when latency is important---it might be better to simply bite the bullet and execute the command at more partitions. This would be particularly helpful in the presence of two (or more) frequent, "conflicting" commands, which even a centralized optimizer might have trouble dealing with. (Of course, synchronizing partitions has its own costs, but even it might still be preferable to first optimistically trying for N times then giving up and doing the full thing, anyway).

Executing multi-partition commands is actually more complicated and non-trivial, partition must exchanging data & signal, which basically introduce big overhead. For example, imagine a command that needs objects A, B, and C, each one in a different partition, P1, P2 e P3. With DynaStar, if we decide to execute the command at P1, then P2 and P3 need to send B and C to P1. Thus, DynaStar requires O(n), where n is the number of partitions involved in the command. Now consider the S-SMR model: P1 has to move A to P2 and P3, P2 has to move B to P1 and P3, …. This is O(n^2)! Besides this, the three partitions will execute the command, against a single one in DynaStar. So, O(n) versus O(1)!

> Contrary to DS-SMR, your oracle is a centralized service. You comment that "introducing centralized components in a distributed system is always a cause for some skepticism, in case the component becomes a bottleneck". You are right, except that there exists an even more important reason for skepticism: fault tolerance. The very purpose of any system based on SMR is to provide availability in the presence of failures. Introducing a single point of failure in the system to improve performance is a bit like having a murderer guard your house against thieves. That said, you could "simply" replace your centralized oracle with a replicated version of it. It would still be a logically centralized service that performs the graph partitioning. Then, of course, one would have to wonder whether the performance would remain the same; especially since you compare with an existing implementation of DS-SMR, whose partitioning oracle is actually implemented as a replicated service.

As stated in the paper, similar to DS-SMR, DynaStar implements the oracle as a regular partition, replicated in a set of nodes, to tolerate failures.

> I am confused about how you guarantee liveness. You state that the system is asynchronous. A replicated state machine is running somewhere inside your system. For an RSM you need consensus, which cannot be both safe and live in an asynchronous system. So I don't see how you can be both safe and live at the same time.

In ridge paper, it assumed partial synchronous system, but the system model changed to asynchronous from S-SMR paper.


> Specific comments:

>-You initially define what you mean by strong locality, but you don't define weak locality. Only after finishing the entire paper, was I able to form an informal definition in my head. You should be explicit about it as soon as you mention it. In the introduction, there is a description of it, but, since you are talking about the workload at the time, it's not clear if that description applies to that workload only, or if it's a definition of weak locality. (Also, there is an earlier mention of weak locality in the previous paragraph.)

should update text.

> -Similarly, when you mention Flitter in the introduction, the reader has no idea what that is.

should update text.

> -Finally, on the "undefined" category: what is "Nest"? I imagine that's a previous name for DynaStar that was not changed.

should update text.

> -In Algorithm 1, how does the "while reply = retry" line accomplish the "eventually fall back to S-SMR"? Is the comment not trying to explain the pseudocode, but rather to augment it? That's a bit weird. You should clarify.

should update algorithm.

> -In IV.D., why is Cj<Zk<Ci a contradiction for the other two cases? Wouldn't Cj<Ci be the contradiction? Why does Zk have to be between Cj and Ci?

...


>-You say: "Our default implementation uses METIS to provide an optimal partitioning based on the workload graph." Earlier, though, you said that METIS's partitioning wasn't optimal. Please clarify.
 
DynaStar chooses the partition for relocation (i.e., one that would minimize the number of state relocations) by partitioning the workload graph using the METIS partitioner. Although METIS does not necessarily produce the best possible partitioning of the workload graph, it offers a good compromise between performance and partitioning quality.

> -In your evaluation, I assume that all your throughput measurements were the peak throughput achieved in your runs. What about latency, though? Under what circumstances did you measure latency? Measuring latency under the same conditions as measuring throughput (i.e. when the system is saturated) does not make sense, as latency is a direct function of the system load in those conditions. Instead, latency should be measured when the system is lightly loaded. Ideally, you could present the entire latency-over-throughput graph, which would give us a more complete picture than the graphs in Figure 3.

Throughput were taken at the peak, and latency was measure at that throughput. It's true that we should take peak throughput and avg latency at low load. 


### Review #136B

> **Summary**
>
> DynaStar is a “scalable” state machine replication (SMR) algorithm, i.e., an SMR algorithm that scales by partitioning the state across multiple machines. Each partition is managed by a group of servers. If all operations are local to a group, operations execute efficiently within the group as in standard SMR, otherwise replicas from different groups need to coordinate. DynaStar models the workload on the fly by building a graph where vertices are state variables and edges model that two variables are accessed by the same command. It then uses a graph partitioning algorithm to identify which variables need to be placed on the same partition, and moves the variables accordingly.


> **Strengths**
>
>  DynaStar improves over existing scalable SMR algorithms.


> **Weaknesses**
>
> The key idea of building a graph of the workload on the fly and using a graph partitioning heuristic on the fly has already been explored in the context of database management systems.

> The costs of the hinting mechanism are not discussed.

**Detail**
> To the best of my knowledge, this is the first paper that combines the use of graph partitioning and data movement to optimize data placement in the context of scalable SMR algorithms. The evaluation shows that the algorithm performs as expected in a simple social networking application: by reconfiguring the system based on the workload observed on the fly, DynaStar is able to achieve the same performance as an optimal static partitioning.

> The main weakness of the paper is that a very similar idea has been concurrently proposed in the context of database management systems. The system is called Clay and it has just appeared in PVLDB 2016. 

>The problem statements of Clay and DynaStar are very related. Clay targets distributed database management systems. These systems also partition the data of the application and replicate each partition for fault tolerance. Requests that access data only of one partition perform very efficiently because they do not need distributed transactions. Therefore, ensuring locality is very important, and this is the purpose of Clay.

>In terms of solution, Clay has several common traits with this paper are: the use of a centralized controller (oracle) to orchestrate a reconfiguration; building a graph on the fly to model the workload dynamically through online monitoring; the use of a graph partitioning heuristic to determine which data needs to be moved across partitions. Clay actually shows that METIS is inadequate for online partitioning and proposes its own heuristic. 

>Unlike Clay, DynaStar propose a complete algorithm for coordinating the execution of requests and moving data across replicas consistently. Clay relies on external mechanisms for this. Given these differences and that the authors of this paper could not have been aware of Clay, I still think that this paper is an interesting read. In general, it would be interesting to see a discussion on where a system like DynaStar would be preferable to a DBMS approach like Clay.

>I would have appreciated seeing a little more detail on the monitoring mechanism. In order to build a graph model for the workload, the oracle of DynaStar collects data about which variables are accessed together. The paper describes the monitoring mechanisms pretty informally. It would have been interesting to see what the cost for online monitoring is, but the evaluation does not discuss this point. On the one hand, if hints are sent to the controller very frequently, the performance cost may be substantial. On the other hand, if hints are sent too infrequently, the workload graph may end up being inaccurate. 

Oracle monitors every requests, and keeps track the ones that change workload graph. When the change exceeds a threshold, Oracle triggers repartitioning process.

> Figure 4 shows that the scalability of the system basically stops at 4 partitions. Is this a problem of the application? Aren’t there cases where DynaStar can scale more?

Figure 4 shows the ideal number of partition for a particular workload. It was meant to show that for a certain workload, there is an optimal partition configuration for it. DynaStar could scale with more partition, but with less benefit than the optimal configuration.

> It would have been nice to see how much data is moved by DynaStar.

Figure 1 compares move between DynaStar and DS-SMR on weak and strong locality workloads.

>I would expect that in some cases there can be a huge performance degradation while data movement is ongoing. I was surprised to see that the degradation is relatively minor in figure 5a. A little more discussion on this point would be interesting.

Data movement goes together with execution of commands, and only touches the pieces of data that are accessed by command. Reconfiguration process only changes the hint of the oracle.

> In Section VI.B, the workload is characterized in terms of the edge cut. This is confusing. Which edge cut is the text referring to? The one produced by METIS? 

Explain edge cut...

>Would not it be be better to characterize the input using parameters that are independent of the specific techniques being proposed in this paper?

It is. graph was generated by Holme-Kim model with some parametter.



---

### Review #136C

> **Summary**
>
> This paper introduces DynaStar a novel solution for scalable state machine replication through dynamic state partitioning. The novelty in DynaStar approach lies in using a graph partitioning approach to partition the state in an efficient manner. Support to dynamic workload happens by periodic partitioning.


> **Strengths**
>
> - Using graph partitioning to partition the state is a novel and very interesting idea.
> - The paper is well written and reasonably easy to read


> **Weaknesses**
>
> - The usage of METIS for graph partitioning is not justified, especially considering that several more efficient alternatives exists in the literature
> - DynaStar uses a centralized oracle to handle requests and calculate state partitioning. The oracle needs to be fault tolerant for the system to work. How can this be implemented? Through SMR?


**Detail**

> The periodic approach to partitioning needed to support dynamic workloads looks a bit naive. Would not monitoring the requests at the oracle to asses the current partitioning be more effective?

Oracle monitors every requests, and keeps track the ones that change workload graph. When the change exceeds a threshold, Oracle triggers repartitioning process.

> DynaStar uses METIS to partition the graph representing the state. The choice is not substantiated by adequate reasoning. Several more effective partitioning algorithms have been recently presented (as an example check C. Xie, L. Yan, W.-J. Li, and Z. Zhang. Distributed power-law graph computing: Theoretical and empirical analysis. In Advances in Neural Information Processing Systems, 2014 and F. Petroni, L. Querzoni, K. Daudjee, S. Kamali and G. Iacoboni: HDRF: Stream-Based Partitioning for Power-Law Graphs. CIKM 2015: 243-252) and it has been show that the best partitioning approach depends on both what you have to partition and why you have to partition it (check the very recent Shiv Verma, Luke M. Leslie, Yosub Shin, Indranil Gupta: An Experimental Comparison of Partitioning Strategies in Distributed Graph Processing. PVLDB 10(5): 493-504 (2017)). From my point of view this choice deserves a more insightful discussion.

Partitioner is pluggable... Although METIS does not necessarily produce the best possible partitioning of the workload graph, it offers a good compromise between performance and partitioning quality.

> The claim of DynaStar being "Quasi-optimum" does not seem to be substantiated by facts.

...

> The experiments based on a social network workload were based on a synthetic dataset. Why not using one of the many real social network graphs available as open datasets? Furthermore the paper provides scarce details on this workload: which kind of distribution is used to mimik user posts? Which kind of inter-arrival times between posts?

... *we did, not really good* 

> The synthetic social network used in the experiments was made up of 10000 users. Available REAL datasets typically range 1-10 million users. Would size be an issue for DynaStar?

... *same as above*

> Why testing with a maximum of 8 partitions? Is this solution is designed to scale I would expect something (a lot) larger.

... *could be tested with 16, but should test with weak locality*

> In the intro "It describes Flitter to demonstrate how Nest can be used to implement a scalable social network service.". Nest what?!?

should update the text




---

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