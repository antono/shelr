require 'fileutils'
require 'json'

module Shelr

  APP_NAME       = 'shelr'
  API_URL        = ENV['SHELR_LOCAL'] ? 'http://localhost:3000' : 'http://shelr.tv'
  XDG_DATA_DIR   = ENV['XDG_DATA_HOME']   || File.join(ENV['HOME'], '.local', 'share')
  XDG_CONFIG_DIR = ENV['XDG_CONFIG_HOME'] || File.join(ENV['HOME'], '.config')
  DATA_DIR       = File.join(XDG_DATA_DIR,   APP_NAME)
  CONFIG_DIR     = File.join(XDG_CONFIG_DIR, APP_NAME)
  API_KEY_CFG    = File.join(CONFIG_DIR, 'api_key')
  BACKEND_CFG    = File.join(CONFIG_DIR, 'backend')

  autoload :Recorder,  'shelr/recorder.rb'
  autoload :Player,    'shelr/player.rb'
  autoload :Publisher, 'shelr/publisher.rb'
  autoload :TTYRec,    'shelr/ttyrec.rb'
  autoload :Terminal,  'shelr/terminal.rb'
  autoload :VERSION,   'shelr/version.rb'

  class << self
    def api_key
      return false unless File.exist?(API_KEY_CFG)
      @api_key ||= File.read(API_KEY_CFG).strip
    end

    def api_key=(key)
      ensure_config_dir_exist
      File.open(API_KEY_CFG, 'w+') { |f| f.puts(key.strip) }
    end

    def backend
      @backend ||= File.exist?(BACKEND_CFG) ? File.read(BACKEND_CFG).strip : 'script'
    end

    def backend=(bin)
      unless ['script', 'ttyrec'].include?(bin)
        puts "Backend should be either `script` or `ttyrec`"
        exit 1
      end
      ensure_config_dir_exist
      File.open(BACKEND_CFG, 'w+') { |f| f.puts(bin.strip) }
    end

    def data_dir(record_id)
      id = record_id.strip == 'last' ? last_id : record_id.to_s
      File.join(DATA_DIR, id)
    end

    def last_id
      File.basename(Dir[File.join(DATA_DIR, '*')].sort.last)
    end

    def terminal
      @terminal ||= Shelr::Terminal.new
    end

    private

    def ensure_config_dir_exist
      FileUtils.mkdir_p(CONFIG_DIR) unless File.exist?(CONFIG_DIR)
    end
  end

end
