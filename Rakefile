# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'

# Vagrant boxes are going to be put in here
PACKER_OUTPUT_DIR = "dist"

# Version control-related variables
require File.join(File.dirname(__FILE__), "utils/git.rb")
require File.join(File.dirname(__FILE__), "utils/templates.rb")

# Dry run (noop)
$dry_run=ENV["dry_run"] || false

# This will return the correspondent box file from its json template
def vm_json2box(template)
  tpl_vars = vm_tpl_vars(template)
  return "#{PACKER_OUTPUT_DIR}/#{tpl_vars["image_name"]}_#{tpl_vars["image_version"]}-#{$image_revision}.box"
end

def vm_tpl_vars(template)
  return JSON.parse(File.read("#{File.dirname(template)}/vars.json"))
end

# This will return the box file that come out of a json template
def vm_box2json(box_file)
  return $vm_box[box_file]
end

# Build an image using Packer
def build_image(template, revision)
  sh %{ packer build -var-file=#{File.dirname(template)}/vars.json -var 'image_revision=#{revision}' -var 'image_output_directory=#{File.expand_path(PACKER_OUTPUT_DIR)}' #{template}}
end

# Build a vagrant box
def vm_build_image (template, revision)
  output_box = vm_json2box(template)
  unless File.directory?(PACKER_OUTPUT_DIR)
    mkdir(PACKER_OUTPUT_DIR)
  end
  if !$dry_run then
    build_image(template, revision)
  else
    touch output_box
  end
end

# These are the expected box files from which file dependencies
# are generated
$vm_boxes   = {}
FileList.new("**/template.json").each do |vm|
  # Generate the list of vagrant boxes that would come out of each template
  box_file = vm_json2box(vm)
  $vm_boxes[box_file]  = vm

  tpl_vars = vm_tpl_vars(vm)
  task tpl_vars["image_name"] => box_file
end

# Each box is dependent on its json counterpart and also to its 
# relevant provisioner shell scripts (depending on the OS)
$vm_boxes.each do |box_file, json_file|
  if box_file.match("ubuntu") then
    file box_file => FileList.new("scripts/*.sh", "scripts/ubuntu/*.sh", json_file) do
      vm_build_image(json_file, $image_revision)
    end
  end
  if box_file.match("centos") then
    file box_file => FileList.new("scripts/*.sh", "scripts/centos/*.sh", json_file) do
      vm_build_image(json_file, $image_revision)
    end
  end
end

# Basic VM tasks
namespace :vm do
  desc "Build images"
  task :build => $vm_boxes.keys
end

# Default task
task :default => 'vm:build'