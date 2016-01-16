A speedy way to create a Docker Swarm's cluster

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

Bug
* At the moment I have a problem to do all in automatic.. WIP.. Helps
