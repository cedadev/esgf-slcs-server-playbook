# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrant configuration
Vagrant.configure(2) do |config|
  # CentOS 6.8 base box
  config.vm.box = "box-cutter/centos68"

  config.vm.network :private_network, ip: "172.28.128.7"

  # For development, use a shared folder to share a local clone of the
  # esgf-slcs-server Github repo with the vagrant VM
  config.vm.synced_folder "../esgf-slcs-server", "/code/esgf-slcs-server"

  # Use a shell provisioner to disable SELinux before starting
  config.vm.provision :shell, inline: <<-SHELL
set -x

cat > /etc/selinux/config <<-SELINUXCONF
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#       enforcing - SELinux security policy is enforced.
#       permissive - SELinux prints warnings instead of enforcing.
#       disabled - SELinux is fully disabled.
SELINUX=disabled
# SELINUXTYPE= type of policy in use. Possible values are:
#       targeted - Only targeted network daemons are protected.
#       strict - Full SELinux protection.
SELINUXTYPE=targeted
SELINUXCONF
setenforce 0
SHELL

  # Install the esgf-slcs-server using an on-machine installation
  config.vm.provision "install", type: "shell", inline: <<-INSTALL
set -x

yum install -y -q epel-release
yum install -y -q ansible
cd /vagrant
ansible-playbook -i playbook/inventories/localhost -e "@playbook/overrides/development.yml" playbook/playbook.yml
INSTALL
end
