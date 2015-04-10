# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'rake'
require 'json'

# Git-related utilities
require File.join(File.dirname(__FILE__), "git.rb")

module Packer
  # All builds made by packer are going to be place onto this directory
  OUTPUT_DIR = "dist"
  
  # This will return the correspondent box file from its json template
  def self.json2box(tpl_vars)
    return "#{OUTPUT_DIR}/#{tpl_vars["image_name"]}_#{tpl_vars["image_version"]}.box"
  end

  def self.tpl_vars(template)
    return JSON.parse(File.read("#{File.dirname(template)}/vars.json"))
  end

  # This is the actual list of templates to
  # be used by both vagrant and rake
  @@templates = {}

  # Fill the template list with the relevant data
  FileList.new("**/template.json").each do |tpl_file|

    # Image version is dynamically generated according
    # to the current git commit id
    vars = self.tpl_vars(tpl_file)
    vars['image_version'] = "#{vars['image_version']}.#{Git::REVISION.to_i(16)}"

    # 
    @@templates[vars["image_name"]] = { 
      :vars     => vars,
      :template => tpl_file,
      :box      => self.json2box(vars) # where the box file is expected to be
    }
  end

  # This returns the template list
  def self.templates 
    @@templates
  end
end