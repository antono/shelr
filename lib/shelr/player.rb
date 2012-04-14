# encoding: utf-8
require 'net/http'
require 'net/https'
require 'tmpdir'
require 'fileutils'
require 'pathname'

module Shelr
  class Player

    def self.play(id)
      new(id).play
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
      Dir[File.join(Shelr::DATA_DIR, "**", 'meta')].each do |path|
        metadata = JSON.parse(IO.read(path))
        puts "#{metadata["recorded_at"]}: #{metadata["title"]}"
      end
    end

    # TODO: refactore me!
    def self.play_parts_hash(parts)
      Dir.mktmpdir do |dir|
        %w(typescript timing).each do |type|
          File.open(File.join(dir, type), 'w') { |f| f.puts(parts[type]) }
        end
        Shelr.terminal.puts_line
        puts "=> Title: #{parts['title']}"
        puts "=> Description: #{parts['description']}t"
        Shelr.terminal.puts_line
        system "scriptreplay #{File.join(dir, 'timing')} #{File.join(dir, 'typescript')}"
        Shelr.terminal.puts_line
        puts "=> Title: #{parts['title']}"
        puts "=> Description: #{parts['description']}t"
        Shelr.terminal.puts_line
      end
    end

    def initialize(id)
      @record_id = id
    end

    def play
      STDOUT.puts "-=" * (Shelr.terminal.size[:width] / 2)
      puts
      system(scriptreplay_cmd)
      puts
      STDOUT.puts "-=" * (Shelr.terminal.size[:width] / 2)
    end

    def scriptreplay(typescript, timing)
    end

    private

    def record_file(name)
      File.join(Shelr.data_dir(@record_id), name)
    end

    def scriptreplay_cmd
      "scriptreplay #{record_file('timing')} #{record_file('typescript')}"
    end
  end
end
