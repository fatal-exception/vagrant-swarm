restart_master:
	vagrant ssh swarm-master -c "sudo docker restart swarm_master"
cluster_info:
	docker -H :2333 info
