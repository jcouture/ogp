require 'bundler/gem_tasks'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'

RuboCop::RakeTask.new(:rubocop)

RSpec::Core::RakeTask.new(:test)

task default: [:rubocop, :test]
