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

#
# Build an image using Packer
#
def build_image(template)
  tpl_file      = template[:template]
  tpl_vars_file = "#{File.dirname(tpl_file)}/vars.json"
  sh %{ packer build -var-file=#{tpl_vars_file} -var 'image_version=#{template[:vars]['image_version']}' -var 'image_output_directory=#{File.expand_path(Packer::OUTPUT_DIR)}' #{tpl_file}}
end

#
# Update the vagrant descriptive JSON for a box
#
def vagrant_json_update(image_name, version_entry)
  # Load the vagrant JSON file
  json_file = File.new("#{Packer::OUTPUT_DIR}/#{image_name}.json", 'w+')
  json_str  = json_file.read
  
  # Load the JSON data
  begin
    json_data = JSON.load json_str
  rescue JSON::ParserError
    json_data = {
      "name" => image_name,
      "versions" => []
    }
  end

  # This will make sure there are no duplicate
  # entries for each box version specified in the
  # JSON file
  json_data['versions'].each_index do |i|
    box_version = json_data['versions'][i]
    if box_version['version'] == version_entry['version']
      json_data['versions'][i].delete
      break
    end
  end

  # Insert the new version entry
  json_data['versions'].push version_entry
  
  # Write the thing
  json_file.puts JSON.dump json_data
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

  version_entry = {
    "version"   => "#{template[:vars]['image_version']}",
    "providers" => [{
      "name"          => "virtualbox",
      "url"           => File.absolute_path(output_box),
      "checksum_type" => "sha1",
      "checksum"      => Digest::SHA1.file(output_box).hexdigest
    }]
  }

  # Insert the new version entry into its correspondent vagrant JSON file
  vagrant_json_update(image_name, version_entry)
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