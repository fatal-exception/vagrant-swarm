restart_master:
	vagrant ssh swarm-master -c "sudo docker restart swarm_master"
cluster_info:
	docker -H tcp://192.168.1.13:2375 info
