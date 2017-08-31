# -*- mode: ruby -*-
# vi: set ft=ruby :
#

vagrantfile_api_version = "2"

@initConsul = <<SCRIPT
if [[ -z $(docker ps -q) ]] ; then
    sudo docker pull consul
    sudo docker run -dp 8500:8500 --name consul consul
fi
SCRIPT

@initMaster = <<SCRIPT
if [[ -z $(docker ps -q) ]] ; then
    sudo docker pull swarm
    sudo docker run -d --name swarm_master -p 2333:2375 swarm manage consul://192.168.13.253:8500
fi
SCRIPT

@initNode = <<SCRIPT
sudo docker pull swarm
sudo service docker stop
CLUSTER_ID=$(cat /vagrant/cluster_id)
sudo dockerd -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock &>/var/log/docker.log &
echo "Waiting for docker daemon to start" ; sleep 5
sudo docker -H :2375 run -d swarm join --addr=${1}:2375 consul://192.168.13.253:8500
SCRIPT
Vagrant.configure(vagrantfile_api_version) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provision "docker"

  # consul
  config.vm.define "consul" do |node|
    node.vm.network "private_network", ip: "192.168.13.253"
    node.vm.network "forwarded_port", guest: 8500, host: 8500
    node.vm.provision "shell", inline: @initConsul
  end

  config.vm.define "swarm-master" do |node|
    node.vm.network "private_network", ip: "192.168.13.1"
    node.vm.network "forwarded_port", guest: 2333, host: 2333
    node.vm.provision "shell", inline: @initMaster
  end

  [1,2,3].each do |nodeNumber|
    config.vm.define "swarm-node-#{nodeNumber}" do |node|
      node.vm.network "private_network", ip: "192.168.13.#{100+nodeNumber}"
      node.vm.provision "shell", inline: @initNode, args: "192.168.13.#{100+nodeNumber}"
    end
  end
end
