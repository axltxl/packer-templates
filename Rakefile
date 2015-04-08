# -*- mode: ruby -*-
# vi: set ft=ruby :

# Version control-related variables
require File.join(File.dirname(__FILE__), "utils/git.rb")
require File.join(File.dirname(__FILE__), "utils/templates.rb")

# Dry run (noop)
$dry_run=ENV["dry_run"] || false

# Build an image using Packer
def build_image(template, revision)
  sh %{ packer build -var-file=#{File.dirname(template)}/vars.json -var 'image_revision=#{revision}' -var 'image_output_directory=#{File.expand_path(Packer::OUTPUT_DIR)}' #{template}}
end

# Build a vagrant box
def vm_build_image (template, revision)
  output_box = Packer.json2box(template)
  unless File.directory?(Packer::OUTPUT_DIR)
    mkdir(Packer::OUTPUT_DIR)
  end
  if !$dry_run then
    build_image(template, revision)
  else
    touch output_box
  end
end

# These are the expected box files from which file dependencies
# are generated
$vm_boxes   = []
Packer.templates.each do |image_name, tpl|
  
  box_file  = tpl[:box]
  tpl_file  = tpl[:template]

  task image_name => box_file

  # Each box is dependent on its json counterpart and also to its 
  # relevant provisioner shell scripts (depending on the OS)
  if box_file.match("ubuntu") then
    os_scripts = "scripts/ubuntu/*.sh"
  elsif box_file.match("centos") then
    os_scripts = "scripts/centos/*.sh"
  end

  file box_file => FileList.new("scripts/*.sh", os_scripts, tpl_file) do
    vm_build_image(tpl_file, Git::REVISION)
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