- Current successfully create message on the fly. 
    + Oracle have to deal with multiple types of Objects
    + Partition still have to create many objects
    + User have to decide which type of object should be shared among partitions -> persistence data

- Current oracle implementation runs specific algorithm on static attribute(s) to determine partition. 
 
- Instead of creating new object on every partition, we multicast update command to all partition to update their oracle
    + Client broadcast create command to all partition. Only owner create actual object, others update their partition
    + Oracle store information of all objects across partitions instead
    + How to get data from specific partition? Since currently multicast
    +  
        * Synchronize between and server oracle: client's oracle keeps a map of objects itself. Are there any case that client's oracle out of date?
        * Update command comes after read command
    + CORBA: **Objects By Reference**, 
        * VS RMI: does not depends on language
- Caching: store object reference