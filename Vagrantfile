# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "mfcbase"
#  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/saucy/current/saucy-server-cloudimg-i386-vagrant-disk1.box"
  config.vm.provision :shell, :path => "provision/provision.sh"
  config.ssh.forward_agent = true

  config.vm.define "Vanilla" do |vanilla|
  end	  
 
  config.vm.provider "virtualbox" do |vboxmanage|
    # enable symlink creation for sharedfolder
    vboxmanage.customize ["setextradata", :id, "VBoxInternal2/SharedFolderseEnableSymlinksCreate/vagrant-root","1"]
 
    # Don't boot with headless mode
    vboxmanage.gui = true

    # Use VBoxManage to customize the VM. For example to change memory:
    vboxmanage.customize ["modifyvm", :id, "--memory", "1024"]
  end
 


end
