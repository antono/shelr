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
        scriptreplay File.join(dir, 'typescript'), File.join(dir, 'timing')
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
      Shelr.terminal.puts_line
      self.class.scriptreplay record_file('typescript'), record_file('timing')
      Shelr.terminal.puts_line
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
      File.join(Shelr.data_dir(@record_id), name)
    end
  end
end
