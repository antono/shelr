require 'fileutils'
require 'yaml'
require 'json'

module Shelr

  APP_NAME   = 'shelr'
  DATA_DIR   = File.join(ENV['HOME'], '.share', APP_NAME)
  CONFIG_DIR = File.join(ENV['HOME'], '.config', APP_NAME)
  API_KEY    = File.join(CONFIG_DIR, 'api_key')
  API_URL    = ENV['SHELR_LOCAL'] ? 'http://localhost:3000' : 'http://shelr.tv'

  autoload :Recorder,  'shelr/recorder.rb'
  autoload :Player,    'shelr/player.rb'
  autoload :Publisher, 'shelr/publisher.rb'

  class << self
    def api_key
      return false unless File.exist?(API_KEY)
      @api_key ||= File.read(API_KEY).strip
    end

    def api_key=(key)
      FileUtils.mkdir_p(CONFIG_DIR) unless File.exist?(CONFIG_DIR)
      File.open(API_KEY, 'w+') { |f| f.puts(key.strip) }
    end

    def data_dir(record_id)
      File.join(Shelr::DATA_DIR, record_id.to_s)
    end
  end

end
