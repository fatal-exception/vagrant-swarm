restart_master:
	vagrant ssh swarm-master -c "sudo docker restart swarm_master"
cluster_info:
	docker -H :2333 info
cluster_nodes:
	docker -H :2333 run swarm list consul://192.168.13.253:8500/
