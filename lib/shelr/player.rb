# encoding: utf-8
require 'net/http'
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
      resp = Net::HTTP.get(URI.parse(url))
      parts = JSON.parse(resp)

      print "Title:\t"
      puts parts['title']
      print "Description:\t"
      puts parts['description']

      Dir.mktmpdir do |dir|
        %w(typescript timing).each do |type|
          File.open(File.join(dir, type), 'w') { |f| f.puts(parts[type]) }
        end
        puts "+==> Playing... "
        system "scriptreplay #{File.join(dir, 'timing')} #{File.join(dir, 'typescript')}"
        puts "+\n+"
        print "| Title:\t"
        puts parts['title']
        print "| Description:\t"
        puts parts['description']
        puts "`==> The end... "
      end
    end

    def self.list
      Dir[File.join(Shelr::DATA_DIR, "**", 'meta')].each do |path|
        metadata = JSON.parse(IO.read(path))
        puts "#{metadata["created_at"]}: #{metadata["title"]}"
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

    private

    def record_file(name)
      File.join(Shelr.data_dir(@record_id), name)
    end

    def scriptreplay_cmd
      "scriptreplay #{record_file('timing')} #{record_file('typescript')}"
    end
  end
end
