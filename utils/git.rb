# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'rake'

module Git
  REVISION  = `git rev-parse --short HEAD`.chomp
  BRANCH   = `git rev-parse --symbolic-full-name --abbrev-ref HEAD`.chomp.gsub('/', '-')
end