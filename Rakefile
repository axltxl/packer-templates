# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'
require 'digest'

# Version control-related variables
require File.join(File.dirname(__FILE__), "utils/git.rb")

# packer-related utilities
require File.join(File.dirname(__FILE__), "utils/templates.rb")

# Dry run (noop)
$dry_run=ENV["dry_run"] || false

# Build an image using Packer
def build_image(template)
  tpl_file      = template[:template]
  tpl_vars_file = "#{File.dirname(tpl_file)}/vars.json"
  sh %{ packer build -var-file=#{tpl_vars_file} -var 'image_version=#{template[:vars]['image_version']}' -var 'image_output_directory=#{File.expand_path(Packer::OUTPUT_DIR)}' #{tpl_file}}
end

# Build a vagrant box
def vm_build_image (image_name, template)
  output_box = template[:box]
  unless File.directory?(Packer::OUTPUT_DIR)
    mkdir(Packer::OUTPUT_DIR)
  end
  if !$dry_run then
    build_image(template)
  else
    touch output_box
  end

  # Generate the box's json file
  File.new("#{Packer::OUTPUT_DIR}/#{image_name}.json", 'w')
      .puts JSON.dump({
        "name" => image_name,
        "versions" => [{
          "version" => "#{template[:vars]['image_version']}",
          "providers" => [{
            "name" => "virtualbox",
            "url" => File.absolute_path(output_box),
            "checksum_type" => "sha1",
            "checksum" => Digest::SHA1.file(output_box).hexdigest
          }]
        }]
      })
end

# These are the expected box files from which file dependencies
# are generated
$vm_boxes   = []
Packer.templates.each do |image_name, tpl|
  
  box_file  = tpl[:box]
  tpl_file  = tpl[:template]

  # Per image, a task is generated which is dependant
  # on its correspondent box file
  task image_name => box_file

  # Each box is dependent on its json counterpart and also to its 
  # relevant provisioner shell scripts (depending on the OS)
  if box_file.match("ubuntu") then
    os_scripts = "scripts/ubuntu/*.sh"
  elsif box_file.match("centos") then
    os_scripts = "scripts/centos/*.sh"
  end

  file box_file => FileList.new("scripts/*.sh", os_scripts, tpl_file) do
    vm_build_image(image_name, tpl)
  end

  #
  $vm_boxes.push(box_file)
end

# Basic VM tasks
namespace :vm do
  desc "Build images"
  task :build => $vm_boxes
end

# Default task
task :default => 'vm:build'