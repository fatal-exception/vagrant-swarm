# -*- mode: ruby -*-
# vi: set ft=ruby :
#

VAGRANTFILE_API_VERSION = "2"

@initMaster = <<SCRIPT
sudo docker pull swarm
sudo docker run --rm swarm create > /vagrant/cluster_id
SCRIPT

@initNode = <<SCRIPT
CLUSTER_ID=$(cat /vagrant/cluster_id)
sudo docker daemon -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock &
sudo docker pull swarm
docker run -d swarm join --addr=${1}:2375 token://${CLUSTER_ID}
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/vivid64"
  config.vm.provision "docker"

  config.vm.define "swarm-master" do |node|
    node.vm.network "private_network", ip: "192.168.13.1"
    node.vm.provision "shell", inline: @initMaster
  end

  [1,2,3].each do |nodeNumber|
    config.vm.define "swarm-node-#{nodeNumber}" do |node|
      node.vm.network "private_network", ip: "192.168.13.#{100+nodeNumber}"
      node.vm.provision "shell", inline: @initNode, args: "192.168.13.#{100+nodeNumber}"
    end
  end
end
