# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'rake'
require 'json'

require File.join(File.dirname(__FILE__), "git.rb")

module Packer
  #
  OUTPUT_DIR = "dist"
  
  # This will return the correspondent box file from its json template
  def self.json2box(tpl_vars)
    #tpl_vars = self.tpl_vars(template)
    return "#{OUTPUT_DIR}/#{tpl_vars["image_name"]}_#{tpl_vars["image_version"]}.box"
  end

  def self.tpl_vars(template)
    return JSON.parse(File.read("#{File.dirname(template)}/vars.json"))
  end

  def self.tpl_get_list
    FileList.new("**/template.json")
  end

  # This will return the box file that come out of a json template
  def self.box2json(box_file)
    return $vm_box[box_file]
  end

  #
  @@templates = {}

  #
  tpl_get_list.each do |tpl_file|
    vars = self.tpl_vars(tpl_file)
    #
    vars['image_version'] = "#{vars['image_version']}.#{Git::REVISION.to_i(16)}"
    #
    image_name = vars["image_name"]

    #
    @@templates[image_name] = { 
      :vars => vars,
      :template => tpl_file,
      :box => self.json2box(vars)
    }
  end

  def self.templates 
    @@templates
  end
end