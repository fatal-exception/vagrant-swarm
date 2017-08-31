A speedy way to create a Docker Swarm standalone(legacy) cluster, with consul discovery backend.


### Start consul
```
vagrant up consul
```

### Start master
```
vagrant up swarm-master
```

### Start nodes
This vagrantfile support 3 nodes but it is easy to modify
```
vagrant up swarm-node-1
vagrant up swarm-node-2
vagrant up swarm-node-3
```

### Restart cluster
To add new node into the pool you must restart master
```
make restart_cluster
```

### Tasks 
make cluster_info
make cluster_nodes
