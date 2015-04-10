# -*- mode: ruby -*-
# vi: set ft=ruby :

# Configuration file location
require File.join(File.dirname(__FILE__), "site.rb")

# Git-related utilities
require File.join(File.dirname(__FILE__), "utils/git.rb")

# packer-related utilities
require File.join(File.dirname(__FILE__), "utils/templates.rb")

# Get the template specified by $vm_box
# and calculate the relevant information
tpl = Packer.templates[$vm_box]
box_version = tpl[:vars]['image_version']
box_path    = File.absolute_path("#{Packer::OUTPUT_DIR}/#{$vm_box}.json")
box_url     = "file://#{box_path}"

Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox"
  config.vm.box         = $vm_box
  config.vm.box_url     = box_url
  config.vm.box_check_update = true
  config.vm.network :private_network, ip: "192.168.33.10"
  config.vm.provider :virtualbox do |vb|
    vb.gui    = true
    vb.memory = 512
  end
end