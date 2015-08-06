## Dynamic Objects Creation on Scalable State Machine Replication

**Problem**
 
Current implementation of SSMR assumes every object exists everywhere across the partitions on the system, but not necessarily up-to-date. This require an initialization of objects on each partition on starting up phase. 

The question now is: Can we introduce an dynamic creation of objects while still maintain the accuracy and performance of the system

**Current implementation issues**

- Object is created on one partition, other partitions with their associated oracle don't have knowledge of newly created object, thus can't access the object when needed.

**Possible solutions and issues need to be addressed:**

- When create object dynamically, create it globally: application server multicast create command to all available partitions. So object is accessible across partitions
    + Need some mechanisms to set Object owner which is main partition that actually own the object.
   
- Implement a broker oracle which have information of all objects on the SSMR system. So partition create object locally, then inform the global oracle about the object. Whenever a partition need an object, it can ask the broker oracle and fetch the object from the destination.
    + Issues: during the time asking-answering of partition-oracle, object's location could be changed. thus need some verification/retry mechanism.

- Create object locally, the object doesn't need to be accessible by others partition, or oracle doesn't need object's information to calculate which partition object is on. (oracle could base on some static attribute of object to calculate)
    + Have to find another way to partition the object base on some static properties, instead of object's location which is a dynamic property

- Use a memcached solution: store a copy of object on a shared memcached cluster. 