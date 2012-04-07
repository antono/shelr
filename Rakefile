require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

desc 'Run all specs in spec directory'
RSpec::Core::RakeTask.new

task :merge do
  File.open('shelr', 'a+') { |f| f.puts "#/usr/bin/env ruby" }
  `cat lib/shelr.rb lib/shelr/* bin/shelr | grep -v autoload >> shelr`
  `chmod +x ./shelr`
end

task :man do
  `bundle exec ronn shelr.1.ronn`
  `rm shelr.1.html`
end

task :default => :spec
