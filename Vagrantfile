# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrant configuration
Vagrant.configure(2) do |config|
  # CentOS 6.8 base box
  config.vm.box = "box-cutter/centos68"

  config.vm.network :private_network, type: "dhcp"

  # For development, use a shared folder to share a local clone of the
  # esgf-slcs-server Github repo with the vagrant VM
  config.vm.synced_folder "../esgf-slcs-server", "/code/esgf-slcs-server"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Use a shell provisioner to (1) allow direct root access with the same key as
  # the vagrant user and (2) disable SELinux
  config.vm.provision :shell, inline: <<-SHELL
echo "Copying SSH key to root..."
mkdir -p /root/.ssh
cp ~vagrant/.ssh/authorized_keys /root/.ssh

echo "Disabling SELinux..."
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
SHELL

  # Disabling SELinux requires a reboot
  #   This step requires the vagrant-reload plugin - to install, run:
  #     vagrant plugin install vagrant-reload
  config.vm.provision :reload

  # Provision the VM with the Ansible playbook
  config.vm.provision :ansible do |ansible|
    ansible.force_remote_user = false
    ansible.playbook = "playbook/playbook.yml"
    ansible.groups = {
      "esgf_slcs_servers" => "default"
    }
  end
end
