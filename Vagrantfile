# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrant configuration
Vagrant.configure(2) do |config|
  # CentOS 6.8 base box
  config.vm.box = "cedadev/centos6"

  config.vm.network :private_network, ip: "172.28.128.7"

  # For development, use a shared folder to share a local clone of the
  # esgf-slcs-server Github repo with the vagrant VM
  config.vm.synced_folder "../esgf-slcs-server", "/code/esgf-slcs-server"

  # Install the esgf-slcs-server using an on-machine installation
  config.vm.provision "install", type: "shell", inline: <<-INSTALL
set -x

yum install -y -q epel-release
yum install -y -q ansible
cd /vagrant
ansible-playbook -i playbook/inventories/localhost -e "@playbook/overrides/development.yml" playbook/playbook.yml
INSTALL
end
