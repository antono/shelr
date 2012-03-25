$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'fileutils'
require 'pathname'
require 'tmpdir'

# XDG directories
shelr_dir = File.join(Dir.tmpdir, 'shelr')
FileUtils.mkdir_p(shelr_dir)

TEMPDIR = Pathname.new Dir.mktmpdir('test', shelr_dir)
XDG_DATA_DIR = TEMPDIR.join('.local', 'share')
XDG_CONFIG_DIR = TEMPDIR.join('.config')

FileUtils.mkdir_p(XDG_DATA_DIR)
FileUtils.mkdir_p(XDG_CONFIG_DIR)

ENV['XDG_DATA_HOME'] = XDG_DATA_DIR.to_s
ENV['XDG_CONFIG_HOME'] = XDG_CONFIG_DIR.to_s

require 'rspec'
require 'shelr'
require "rubygems"
require "bundler/setup"
require 'pry'
require 'pry-nav'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
