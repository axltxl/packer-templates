# -*- mode: ruby -*-
# vi: set ft=ruby :

# Configuration file location
require File.join(File.dirname(__FILE__), "site.rb")
require File.join(File.dirname(__FILE__), "utils/git.rb")
require File.join(File.dirname(__FILE__), "utils/templates.rb")
 
Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox"
  config.vm.box = $vm_box
  config.vm.box_url = $vm_box_url
  config.vm.network :hostonly, "192.168.33.10"
  config.vm.provider :virtualbox do |vb|
    vb.gui    = true
    vb.memory = 512
  end
endq