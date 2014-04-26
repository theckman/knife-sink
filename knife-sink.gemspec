# -*- coding: UTF-8 -*-
require 'English'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'knife-sink/version'

Gem::Specification.new do |spec|
  spec.name        = 'knife-sink'
  spec.version     = Knife::Sink::VERSION
  spec.date        = Time.now.strftime('%Y-%m-%d')
  spec.description = 'Workstation => Chef Server synchronization'
  spec.summary     = 'Chef knife plugin for synchronizing your Chef server'
  spec.authors     = ['Tim Heckman']
  spec.email       = 't@heckman.io'
  spec.homepage    = 'https://github.com/theckman/knife-sink'
  spec.license     = 'Apache 2.0'
  spec.required_ruby_version = '>= 1.9.3'

  spec.test_files  = %x(git ls-files spec/*).split
  spec.files       = %x(git ls-files).split

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake', '~> 10.2', '>= 10.2.2'
  spec.add_development_dependency 'rubocop', '~> 0.20'
  spec.add_development_dependency 'rspec', '>= 3.0.0.beta2'
  spec.add_development_dependency 'fuubar', '~> 1.3', '>= 1.3.2'
  spec.add_development_dependency 'coveralls', '~> 0.7'
  spec.add_development_dependency 'simplecov', '~> 0.8', '>= 0.8.2'
  spec.add_development_dependency 'chef-zero'
  spec.add_development_dependency 'berkshelf', '~> 3.1'

  spec.add_runtime_dependency 'chef', '~> 11.12.2'
end
