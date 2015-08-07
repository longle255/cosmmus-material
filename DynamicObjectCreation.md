## Dynamic Objects Creation on Scalable State Machine Replication

**Problem**
 
Current implementation of SSMR assumes every object exists everywhere across the partitions on the system, but not necessarily up-to-date. This require an initialization of objects on each partition on starting up phase. 

This lead to the case when object is created on one partition, other partitions with their associated oracle don't have knowledge of newly created object, thus can't access the object when needed.

**Dynamic Object Creation**
- Introduce an dynamic creation of objects that accessible across the partitions
- Handle the case object move across the partitions.


**Possible solutions and issues need to be addressed:**

- When create object dynamically, create it globally: application server multicast create command to all available partitions. So all partitions have a copy of newly created object. Then the object is accessible across partitions
    + Need to set Object owner which is main partition that actually own the object.
    + When the object "moves" to another partition, update the object's owner information to the Oracle
   
- Implement a broker oracle which have information of all objects on the SSMR system. So partition create object locally, then inform the global oracle about the object. Whenever a partition need an object, it can ask the broker oracle and fetch the object from the destination.
    + Issues: during the time asking-answering of partition-oracle, object's location could be changed. thus need some verification/retry mechanism.
    + Could lead to single point of failure problem when central oracle fail to operate.

- Create object locally, the object doesn't need to be accessible by others partition, or oracle doesn't need object's information to calculate which partition object is on. (oracle could base on some static attribute of object to calculate)
    + Have to find another way to partition the object base on some static properties, instead of object's location which is a dynamic property

- Use a memcached solution: store a copy of object on a shared memcached cluster, then partition will first find the local copy then ask the shared memory. 