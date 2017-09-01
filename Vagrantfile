# -*- mode: ruby -*-
# vi: set ft=ruby :
#
require 'erb'

vagrantfile_api_version = "2"

## consul ports needed are %w(8300 8301 8302 8400 8500 8600)

CONSUL_VERSION = "0.7.5"

@initConsul = ERB.new(<<-TEMPLATE).result(binding)
sudo docker pull consul:#{CONSUL_VERSION}
sudo docker rm -f consul || true
docker run -d --name consul --net=host -e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' consul:#{CONSUL_VERSION} agent -server -bind=192.168.13.253 -client=192.168.13.253 -bootstrap-expect=1
TEMPLATE

@initMaster = ERB.new(<<-TEMPLATE).result(binding)
sudo docker pull consul:#{CONSUL_VERSION}
sudo docker pull swarm
sudo docker pull gliderlabs/registrator
sudo docker rm -f swarm_master || true
sudo docker rm -f consul || true
sudo docker rm -f registrator || true
sudo docker rm -f registrator-kv || true
sudo docker run -d -e 'CONSUL_LOCAL_CONFIG={"leave_on_terminate": true}' -v /var/run/docker.sock:/var/run/docker.sock t pu--net=host --name consul consul:#{CONSUL_VERSION} consul agent -bind=192.168.13.1 -client 192.168.13.1 -data-dir=/tmp/consul -retry-join 192.168.13.253
sudo docker run -d --net=host --name swarm_master -p 2333:2375 swarm manage consul://192.168.13.1:8500
sudo docker run -v /var/run/docker.sock:/tmp/docker.sock:rw -d --name registrator gliderlabs/registrator -ip 192.168.13.1 -ttl 600 --ttl-refresh 300 -resync 600 -cleanup consul://192.168.13.1:8500
sudo docker run -v /var/run/docker.sock:/tmp/docker.sock:rw -d --name registrator-kv gliderlabs/registrator -ip 192.168.13.1 consulkv://192.168.13.1:8500/services

sudo docker exec consul apk update 
sudo docker exec consul apk add docker
sudo docker exec consul chmod 666 /var/run/docker.sock
TEMPLATE

@initNode = ERB.new(<<-TEMPLATE).result(binding)
sudo docker pull swarm
sudo docker pull consul:#{CONSUL_VERSION}
docker rm -f consul || true
docker rm -f swarm || true
docker rm -f registrator || true
docker rm -f registrator-kv || true
sudo service docker stop
sudo dockerd -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock &>/var/log/docker.log &
echo "Waiting for docker daemon to start" ; sleep 5
sudo docker -H :2375 run -d --name swarm swarm join --addr=${1}:2375 consul://${1}:8500
sudo docker -H :2375 run -v /var/run/docker.sock:/var/run/docker.sock:rwx -d -e 'CONSUL_LOCAL_CONFIG={"leave_on_terminate": true}' --net=host --name consul consul:#{CONSUL_VERSION} consul agent -bind=${1} -client=${1} -data-dir=/tmp/consul -retry-join 192.168.13.253
sudo docker run -v /var/run/docker.sock:/tmp/docker.sock:rw -d --name registrator gliderlabs/registrator -ip ${1} -ttl 600 --ttl-refresh 300 -resync 600 -cleanup consul://${1}:8500
sudo docker run -v /var/run/docker.sock:/tmp/docker.sock:rw -d --name registrator-kv gliderlabs/registrator -ip ${1} consulkv://${1}:8500/services

sudo docker exec consul apk update 
sudo docker exec consul apk add docker
sudo docker exec consul chmod 666 /var/run/docker.sock
TEMPLATE

Vagrant.configure(vagrantfile_api_version) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provision "docker"

  # consul
  config.vm.define "consul" do |node|
	node.vm.hostname = "consul"
    node.vm.network "private_network", ip: "192.168.13.253"
    node.vm.provision "shell", inline: @initConsul
  end

  config.vm.define "swarm-master" do |node|
    node.vm.hostname = "swarm-master"
    node.vm.network "private_network", ip: "192.168.13.1"
    node.vm.network "forwarded_port", guest: 2333, host: 2333
    node.vm.provision "shell", inline: @initMaster
  end

  [1,2,3].each do |nodeNumber|
    config.vm.define "swarm-node-#{nodeNumber}" do |node|
      node.vm.hostname = "swarm-node-#{nodeNumber}"
      node.vm.network "private_network", ip: "192.168.13.#{100+nodeNumber}"
      node.vm.provision "shell", inline: @initNode, args: "192.168.13.#{100+nodeNumber}"
    end
  end
end
