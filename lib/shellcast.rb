require 'rubygems'
require 'fileutils'
require 'colored'
require 'xdg'
require 'yaml'
require 'json'

module ShellCast

  APP_NAME   = 'shellcast'
  DATA_DIR   = File.join(XDG::Data.home,   APP_NAME)
  CONFIG_DIR = File.join(XDG::Config.home, APP_NAME)
  API_KEY    = File.join(CONFIG_DIR, 'api_key')
  API_URL    = ENV['SC_LOCAL'] ? 'http://localhost:3000' : 'http://shell.heroku.com'

  class << self
    def api_key
      return false unless File.exist?(API_KEY)
      @api_key ||= File.read(API_KEY).strip
    end

    def api_key=(key)
      FileUtils.mkdir_p(CONFIG_DIR) unless File.exist?(CONFIG_DIR)
      File.open(API_KEY, 'w+') do |f|
        f.puts(key.strip)
      end
    end

    def shellcast_dir(shellcast_id)
      File.join(ShellCast::DATA_DIR, shellcast_id.to_s)
    end
  end

  autoload :Recorder,  'shellcast/recorder.rb'
  autoload :Player,    'shellcast/player.rb'
  autoload :Publisher, 'shellcast/publisher.rb'

end
