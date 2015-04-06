# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrant boxes are going to be put in here
PACKER_OUTPUT_DIR = "dist"

# Version control-related variables
git_rev     = `git rev-parse --short HEAD`.chomp
git_branch  = `git rev-parse --symbolic-full-name --abbrev-ref HEAD`.chomp.gsub('/', '-')

# Image versioning details (these are inserted into Packer)
$image_version = "#{git_branch}-#{git_rev}"
$image_name_prefix = "base"

# Dry run (noop)
$dry_run=ENV["dry_run"] || false

# This will return the correspondent box file from its json template
def vm_json2box(json_file, prefix, append_output_dir=true)
  box_file = json_file.clone
  if append_output_dir then
    box_file.sub!(/^#{Regexp.quote(prefix)}-/, "#{PACKER_OUTPUT_DIR}/#{$image_name_prefix}_")
  else
    box_file.sub!(/^#{Regexp.quote(prefix)}-/, "#{$image_name_prefix}_")
  end
  box_file.sub(/\.json$/, "_#{$image_version}.box")
end

# This will return the box file that come out of a json template
def vm_box2json(box_file, prefix)
  json_file = box_file.clone
  json_file.sub(/^#{Regexp.quote(PACKER_OUTPUT_DIR)}\/#{Regexp.quote($image_name_prefix)}_/, "#{prefix}-")
           .sub(/_#{Regexp.quote($image_version)}.box$/,'.json')
end

# Build an image using Packer
def build_image(template, version)
  sh %{ packer build -var 'image_version=#{version}' -var 'image_name_prefix=#{$image_name_prefix}' #{template}}
end

# Build a vagrant box
def vm_build_image (template, version)
  output_box = vm_json2box(template, "vm", false)
  unless File.directory?(PACKER_OUTPUT_DIR)
    mkdir(PACKER_OUTPUT_DIR)
  end
  if !$dry_run then
    build_image(template, version, "vm")
  else
    touch output_box
  end
  rmtree "build"
  mv output_box, "#{PACKER_OUTPUT_DIR}/"
end

# These are the expected box files from which file dependencies
# are generated
$vm_boxes = []
FileList.new("*.json").each do |vm|
  # Generate the list of vagrant boxes that would come out of each template
  $vm_boxes.push(vm_json2box(vm, "vm"))

  # Generate a single task per single json template:
  # It will build a box regardless of any dependencies
  # e.g. rake vm-ubuntu-14.04-x64.json
  task "#{vm}" do
    vm_build_image(vm, $image_version)
  end 

end

# Each box is dependent on its json counterpart and also to its 
# relevant provisioner shell scripts (depending on the OS)
$vm_boxes.each do |box|
  json_file = vm_box2json(box, "vm")
  if box.match("ubuntu") then
    file box => FileList.new("scripts/*.sh", "scripts/ubuntu/*.sh", json_file) do
      vm_build_image(vm_box2json(box, "vm"), $image_version)
    end
  end
  if box.match("centos") then
    file box => FileList.new("scripts/*.sh", "scripts/centos/*.sh", json_file) do
      vm_build_image(vm_box2json(box, "vm"), $image_version)
    end
  end
end

# Basic VM tasks
namespace :vm do
  desc "Build images"
  task :build => $vm_boxes
end

# Default task
task :default => 'vm:build'