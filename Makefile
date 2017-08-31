restart_master:
	vagrant ssh swarm-master -c "sudo docker restart swarm_master"
cluster_info:
	vagrant ssh swarm-master -c "sudo docker -H :2333 info"
