# Resources collection for Cosmmus Project

## Table of content
<!-- MarkdownTOC -->

- Papers
    - *Balan, R. K., Ebling, M., Castro, P., & Misra, A. (2005)*. **Matrix: Adaptive Middleware for Distributed Multiplayer Games.** Middleware, 3790(Chapter 20), 390–400. http://doi.org/10.1007/11587552_20
    - *Lui, J. C. S., & Chan, M. F. (2002)*. **An Efficient Partitioning Algorithm for Distributed Virtual Environment Systems.** IEEE Trans. Parallel Distrib. Syst. (), 13(3), 193–211. http://doi.org/10.1109/71.993202
    - *Morillo, P., Orduña, J. M., Fernández, M., & Duato, J. (2005)*. **Improving the performance of distributed virtual environment systems.** Parallel and Distributed Systems, IEEE Transactions on, 16(7), 637–649. http://doi.org/10.1109/TPDS.2005.83
- Existing Framework
    - Smartfox Server
    - Bigworld Server

<!-- /MarkdownTOC -->

## Papers

##### *Balan, R. K., Ebling, M., Castro, P., & Misra, A. (2005)*. **Matrix: Adaptive Middleware for Distributed Multiplayer Games.** Middleware, 3790(Chapter 20), 390–400. http://doi.org/10.1007/11587552_20

* **Link**

    [Link to paper](papers/1FF35410-3053-43CD-B6DF-AAC3C37B3B82.pdf)

* **Abstract**

    Building a distributed middleware infrastructure that provides the low  latency required for massively multiplayer games while still maintaining  consistency is non-trivial.Previous attempts have used static partitioning or client-based peer-to-peer techniques that do not scale well to a large number of players, per- form poorly under dynamic workloads or hotspots, and impose significant pro- gramming burdens on game developers. We show that it is possible to build a scalable distributed system, called Matrix, that is easily usable by game develop- ers. We show experimentally that Matrix provides good performance, especially when hotspots occur.

* **Discuss** 

    N/A

##### *Lui, J. C. S., & Chan, M. F. (2002)*. **An Efficient Partitioning Algorithm for Distributed Virtual Environment Systems.** IEEE Trans. Parallel Distrib. Syst. (), 13(3), 193–211. http://doi.org/10.1109/71.993202

* **Link**

    [Link to paper](papers/A9C82E3B-D723-458C-88AF-BA3E52541085.pdf)

* **Abstract**

    Distributed virtual environment 􏰆DVE) systems model and simulate the activities of thousands of entities interacting in a virtual world over a wide area network. Possible applications for DVE systems are multiplayer video games, military and industrial trainings, and collaborative engineering. In general, a DVE system is composed of many servers and each server is responsible to manage multiple clients who want to participate in the virtual world. Each server receives updates from different clients 􏰆such as the current position and orientation of each client) and then delivers this information to other clients in the virtual world. The server also needs to perform other tasks, such as object collision detection and synchronization control. A large scale DVE system needs to support many clients and this imposes a heavy requirement on networking resources and computational resources. Therefore, how to meet the growing requirement of bandwidth and computational resources is one of the major challenges in designing a scalable and cost-effective DVE system. In this paper, we propose an efficient partitioning algorithm that addresses the scalability issue of designing a large scale DVE system. The main idea is to dynamically divide the virtual world into different partitions and then efficiently assign these partitions to different servers. This way, each server will process approximately the same amount of workload. Another objective of the partitioning algorithm is to reduce the server-to-server communication overhead. The theoretical foundation of our dynamic partitioning algorithm is based on the linear optimization principle. We also illustrate how one can parallelize the proposed partitioning algorithm so that it can efficiently partition a very large scale DVE system. Lastly, experiments are carried out to illustrate the effectiveness of the proposed partitioning algorithm under various settings of the virtual world.
* **Discuss** 
    
    N/A

##### *Morillo, P., Orduña, J. M., Fernández, M., & Duato, J. (2005)*. **Improving the performance of distributed virtual environment systems.** Parallel and Distributed Systems, IEEE Transactions on, 16(7), 637–649. http://doi.org/10.1109/TPDS.2005.83

* **Link**

    [Link to paper](papers/7A0F3CE0-8295-4CAD-842B-8FDA46CDA23A.pdf)

* **Abstract**

    The last years have witnessed a dramatic growth in the number as well as in the variety of distributed virtual environment systems. These systems allow multiple users, working on different client computers that are interconnected through different networks, to interact in a shared virtual world. One of the key issues in the design of scalable and cost-effective DVE systems is the partitioning problem. This problem consists of efficiently assigning the existing clients to the servers in the system and some techniques have been already proposed for solving it. This paper experimentally analyzes the correlation of the quality function proposed in the literature for solving the partitioning problem with the performance of DVE systems. Since the results show an absence of correlation, we also propose the experimental characterization of DVE systems. The results show that the reason for that absence of correlation is the nonlinear behavior of DVE systems with regard to the number of clients in the system. DVE systems reach saturation when any of the servers reaches 100 percent of CPU utilization. The system performance greatly decreases if this limit is exceeded in any server. Also, as a direct application of these results, we present a partitioning method that is targeted to keep all the servers in the system below a certain threshold value of CPU utilization, regardless of the amount of network traffic. Evaluation results show that the proposed partitioning method can improve DVE system performance, regardless of both the movement pattern of clients and the initial distribution of clients in the virtual world.
* **Discuss** 

    N/A


## Existing Framework

##### Smartfox Server

##### Bigworld Server