# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'rake'

# Version control-related variables
$git_rev     = `git rev-parse --short HEAD`.chomp
$git_branch  = `git rev-parse --symbolic-full-name --abbrev-ref HEAD`.chomp.gsub('/', '-')
$image_revision = "#{$git_branch}-#{$git_rev}"

$vm_boxes = FileList.new("**/template.json")