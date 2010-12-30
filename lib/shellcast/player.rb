# encoding: utf-8
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
