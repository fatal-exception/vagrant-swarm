restart_swarm_master:
	vagrant ssh swarm-master -c "sudo docker restart swarm_master"
swarm_info:
	vagrant ssh swarm-master -c 'docker -H 192.168.13.1:2375 info'
swarm_nodes:
	vagrant ssh swarm-master -c "docker run swarm list consul://192.168.13.1:8500/"
consul_nodes:
	vagrant ssh consul -c 'curl 192.168.13.253:8500/v1/catalog/nodes' | python -m json.tool
consul_services:
	vagrant ssh consul -c 'curl 192.168.13.253:8500/v1/catalog/services' | python -m json.tool
consul_service:
	vagrant ssh consul -c 'curl 192.168.13.253:8500/v1/catalog/service/$(service)' | python -m json.tool
consul_healthchecks:
	vagrant ssh consul -c 'curl -i 192.168.13.253:8500/health/checks/$(service)'
