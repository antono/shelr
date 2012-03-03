ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"

require "rubygems"
require "bundler/setup"
require 'aruba/cucumber'

# Aruba.configure do |config|
#   config.before_cmd do |cmd|
#     puts "About to run `#{cmd}`"
#   end
# end
