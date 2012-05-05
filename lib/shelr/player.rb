# encoding: utf-8
require 'net/http'
require 'net/https'
require 'tmpdir'
require 'fileutils'
require 'pathname'

module Shelr
  class Player

    def self.play(options)
      new.play(options)
    end

    def self.play_remote(url)
      puts ".==> Fetching #{url}"
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == "https"
      resp = http.request_get(uri.path).body
      play_parts_hash(JSON.parse(resp))
    end

    def self.play_dump(file)
      json = File.read(file)
      parts = JSON.parse(json)
      play_parts_hash(parts)
    end

    def self.list
      (Dir[File.join(Shelr::DATA_DIR, "**")] - ['.', '..']).sort.each do |dir|
        metadata = JSON.parse(IO.read(File.join(dir, 'meta')))
        puts "#{metadata["recorded_at"]} : #{metadata["title"]}"
      end
    end

    # TODO: refactore me!
    def self.play_parts_hash(parts)
      Dir.mktmpdir do |dir|
        %w(typescript timing).each do |type|
          File.open(File.join(dir, type), 'w') { |f| f.puts(parts[type]) }
        end
        play(:record_dir => dir)
      end
    end

    def play(options = {})
      @options = options
      start_sound_player
      Shelr.terminal.puts_line
      self.class.scriptreplay record_file('typescript'), record_file('timing')
      Shelr.terminal.puts_line
      stop_sound_player
    end

    def start_sound_player
      return unless File.exist?(record_file('sound.ogg'))
      at_exit { system('stty echo') }
      STDOUT.puts "=> Starting sound player..."
      @sox_pid = fork do
        `play #{record_file('sound.ogg')} 2>&1`
      end
    end

    def stop_sound_player
      return unless File.exist?(record_file('sound.ogg'))
      STDOUT.puts "=> Stopping sound player..."
      Process.kill("HUP", @sox_pid)
    end

    def self.scriptreplay(typescript_file, timing_file)
      typescript = File.open(typescript_file)
      timing = File.open(timing_file)
      frames = timing.read.split("\n").map { |line| line.split(" ") }
      frames.map! { |k,v| [k.to_f.abs, v.to_i] }
      typescript.gets # skip first line

      frames.each do |usec,length|
        sleep(usec)
        print typescript.read(length)
      end
    end

    private

    def record_file(name)
      File.join(record_dir, name)
    end

    def record_dir
      @options[:record_id] ? Shelr.data_dir(@options[:record_id]) : @options[:record_dir]
    end
  end
end
