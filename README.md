# Scaling State-Machine Replication

## RDMA Message queue

in progress...

## DynaStar: Optimized Dynamic Partitioning for Scalable State Machine Replication

Long Hoang Le, Enrique Fynn, Mojtaba Eslahi-Kelorazi, Robert Soulé, Fernando Pedone

*39th International Conference on Distributed Computing Systems (ICDCS), July 2019, Texas, US.*

Classic state machine replication (SMR) does not scale well, since
each replica must execute every command.  To address this problem,
several systems have investigated the use of state partitioning in the
context of SMR, allowing client commands to be executed on a subset of
replicas. Prior approaches range from completely static schemes, which do not
adapt as workloads change, to dynamic schemes, which move data on-demand.


This paper presents DynaStar, a new dynamic partitioning scheme for
scaling state machine replication. In contrast to prior dynamic
schemes, DynaStar uses a replicated location oracle to maintain a global view
of the workload and inform heuristics about data placement. Using this
oracle, DynaStar can adapt to workload changes over time,
while also minimizing the number of state moves. The result is a
practical technique that achieves excellent performance.

## Dynamic Scalable State Machine Replication
Long Hoang Le, Carlos Eduardo Bezerra, Fernando Pedone

*46th Annual International Conference on Dependable Systems and Networks (DSN), 2016, Toulouse, France.*

State machine replication (SMR) is a well-known technique that guarantees strong consistency (i.e., linearizability) to online services. In SMR, client commands are executed in the same order on all server replicas, and after executing each command, every replica reaches the same state. However, SMR lacks scalability: every replica executes all commands, so adding servers does not increase the maximum throughput. Scalable SMR (S-SMR) addresses this problem by partitioning the service state, allowing commands to execute only in some replicas, providing scalability while still ensuring linearizability. One problem is that S-SMR quickly saturates when executing multi-partition commands, as partitions must communicate. Dynamic S-SMR (DS-SMR) solves this issue by repartitioning the state dynamically, based on the workload. Variables that are usually accessed together are moved to the same partition, which significantly improves scalability. We evaluate the performance of DS-SMR with a scalable social network application.

## Strong Consistency at Scale

Carlos Eduardo Bezerra, Long Hoang Le, Fernando Pedone

*Bulletin of the IEEE Computer Society Technical Committee on Data Engineering, March 2016, 39(1).*

Today’s online services must meet strict availability and performance requirements. State machine replication, one of the most fundamental approaches to increasing the availability of services without sacrificing strong consistency, provides configurable availability but limited performance scalability. Scalable State Machine Replication (S-SMR) achieves scalable performance by partitioning the service state and coordinating the ordering and execution of commands. While S-SMR scales the performance of single-partition commands with the number of deployed partitions, replica coordination needed by multi-partition commands introduces an overhead in the execution of multi-partition commands. In the paper, we review Scalable State Machine Replication and quantify the overhead due to replica coordi- nation in different scenarios. In brief, we show that performance overhead is affected by the number of partitions involved in multi-partition commands and data locality.
