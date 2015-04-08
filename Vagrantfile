# -*- mode: ruby -*-
# vi: set ft=ruby :

# Configuration file location
require File.join(File.dirname(__FILE__), "site.rb")
require File.join(File.dirname(__FILE__), "utils/git.rb")
require File.join(File.dirname(__FILE__), "utils/templates.rb")
 
Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox"
  config.vm.box = $vm_box
  config.vm.box_url = "dist/#{$vm_box}_#{$image_revision}.box"
  config.vm.network :hostonly, ip: "192.168.33.10"
  config.vm.provider :virtualbox do |vb|
    vb.gui    = true
    vb.memory = 512
  end
end