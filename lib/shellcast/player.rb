# encoding: utf-8
require 'net/http'
require 'tmpdir'
require 'fileutils'
require 'pathname'

module ShellCast
  class Player

    HEADER = <<-EOH
                                                               
            █             ███    ███                               
      ▓███▒ █               █      █     ░███▒                 █   
     █▓  ░█ █               █      █    ░█▒ ░█                 █   
     █      █▒██▒   ███     █      █    █▒     ░███░  ▒███▒  █████ 
     █▓░    █▓ ▒█  ▓▓ ▒█    █      █    █      █▒ ▒█  █▒ ░█    █   
      ▓██▓  █   █  █   █    █      █    █          █  █▒░      █   
         ▓█ █   █  █████    █      █    █      ▒████  ░███▒    █   
          █ █   █  █        █      █    █▒     █▒  █     ▒█    █   
     █░  ▓█ █   █  ▓▓  █    █░     █░   ░█▒ ░▓ █░ ▓█  █░ ▒█    █░  
     ▒████░ █   █   ███▒    ▒██    ▒██   ▒███▒ ▒██▒█  ▒███▒    ▒██ 


                         .----------------.
                        ' Playback started '
    EOH

    FOOTER = <<-EOF
            █                                      █ 
    ███████ █                    ██████            █ 
       █    █                    █                 █ 
       █    █▒██▒   ███          █      █▒██▒   ██▓█ 
       █    █▓ ▒█  ▓▓ ▒█         █      █▓ ▒█  █▓ ▓█ 
       █    █   █  █   █         ██████ █   █  █   █ 
       █    █   █  █████         █      █   █  █   █ 
       █    █   █  █             █      █   █  █   █ 
       █    █   █  ▓▓  █         █      █   █  █▓ ▓█ 
       █    █   █   ███▒         ██████ █   █   ██▓█ 

    EOF


    def self.play(id)
      new(id).play
    end

    def self.play_remote(url)
      puts ".==> Fetching #{url}".white_on_black
      resp = Net::HTTP.get(URI.parse(url))
      parts = JSON.parse(resp)

      print "| Title:\t".yellow
      puts parts['title']
      print "| Description:\t".yellow
      puts parts['description']

      Dir.mktmpdir do |dir|
        %w(typescript timing).each do |type|
          File.open(File.join(dir, type), 'w') { |f| f.puts(parts[type]) }
        end
        puts "+==> Playing... ".white_on_black
        system "scriptreplay #{File.join(dir, 'timing')} #{File.join(dir, 'typescript')}"
        puts "+\n+"
        print "| Title:\t".yellow
        puts parts['title']
        print "| Description:\t".yellow
        puts parts['description']
        puts "`==> The end... ".white_on_black
      end
    end

    def self.list
      Dir[File.join(ShellCast::DATA_DIR, "**", 'meta')].each do |path|
        metadata = JSON.parse(IO.read(path))
        puts "#{metadata["created_at"]}: #{metadata["title"]}"
      end
    end

    def initialize(id)
      @shellcast_id = id
    end

    def play
      puts HEADER.black_on_white
      puts
      system(scriptreplay_cmd)
      puts
      puts FOOTER.black_on_white
    end

    private

    def shellcast_file(name)
      File.join(ShellCast.shellcast_dir(@shellcast_id), name)
    end

    def scriptreplay_cmd
      "scriptreplay #{shellcast_file('timing')} #{shellcast_file('typescript')}"
    end
  end
end
