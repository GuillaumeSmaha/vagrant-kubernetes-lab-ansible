# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

 config.vm.provision :shell, :inline => "ulimit -n 4096"

  ############################################################
  #                   Gluu Cluster Manager
  ############################################################

  config.vm.define "gluu-cluster-manager" do |gluu|
    
    gluu.vm.box = "fgrehm/trusty64-lxc"
    gluu.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update
      sudo apt-get -y install python apt-transport-https
    SHELL

    gluu.vm.network "private_network", ip: "192.168.100.10", netmask: "255.255.255.0", lxc__bridge_name: 'vlxcbr1'
    gluu.vm.network :forwarded_port, guest: 6000, host: 5080
    gluu.vm.hostname = "gluu-cluster-manager"
  end

  ############################################################
  #                   Gluu Main Node
  ############################################################

  config.vm.define "gluu-main-oxtrust" do |gluu|
    
    gluu.vm.box = "my/centos-7-lxc"
    gluu.vm.provision "shell", inline: <<-SHELL
       sudo yum makecache fast
       sudo yum makecache
       sudo yum -y install python epel-release
     SHELL

    gluu.vm.network "private_network", ip: "192.168.100.20", netmask: "255.255.255.0", lxc__bridge_name: 'vlxcbr1'
    gluu.vm.hostname = "gluu-main-oxtrust"
  end

  config.vm.define "gluu-main-oxauth" do |gluu|
    
    gluu.vm.box = "my/centos-7-lxc"
    gluu.vm.provision "shell", inline: <<-SHELL
      sudo yum makecache fast
       sudo yum makecache
       sudo yum -y install python epel-release
     SHELL

    gluu.vm.network "private_network", ip: "192.168.100.21", netmask: "255.255.255.0", lxc__bridge_name: 'vlxcbr1'
    gluu.vm.hostname = "gluu-main-oxauth"
  end


  ############################################################
  #                   Gluu Consumer Node
  ############################################################

  (1..2).each do |i|
    config.vm.define "gluu-consumer-#{i}" do |gluu|
      
      gluu.vm.box = "my/centos-7-lxc"
      gluu.vm.provision "shell", inline: <<-SHELL
         sudo yum makecache fast
         sudo yum makecache
         sudo yum -y install python epel-release
       SHELL
  
      gluu.vm.network "private_network", ip: "192.168.100.10#{i}", netmask: "255.255.255.0", lxc__bridge_name: 'vlxcbr1'
      gluu.vm.hostname = "gluu-consumer-#{i}"
    end
  end

end
