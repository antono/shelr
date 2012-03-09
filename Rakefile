require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

desc 'Run all specs in spec directory'
RSpec::Core::RakeTask.new

task :default => :spec
