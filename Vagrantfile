# -*- mode: ruby -*-
# vi: set ft=ruby :

# Configuration file location
require File.join(File.dirname(__FILE__), "site.rb")
require File.join(File.dirname(__FILE__), "utils/git.rb")
require File.join(File.dirname(__FILE__), "utils/templates.rb")

tpl = Packer.templates[$vm_box]
box_version = tpl[:vars]['image_version']
box_url     = "#{Packer::OUTPUT_DIR}/#{tpl[:vars]['image_name']}.json"

Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox"
  config.vm.box         = $vm_box
  config.vm.box_url     = "file://#{File.absolute_path(box_url)}"
  config.vm.box_check_update = true
  config.vm.network :private_network, ip: "192.168.33.10"
  config.vm.provider :virtualbox do |vb|
    vb.gui    = true
    vb.memory = 512
  end
end