module ShellCast
  class Player

    HEADER = <<-EOH
     ____  _          _ _  ____          _   
    / ___|| |__   ___| | |/ ___|__ _ ___| |_ 
    \\___ \\| '_ \\ / _ \\ | | |   / _` / __| __|
     ___) | | | |  __/ | | |__| (_| \\__ \\ |_ 
    |____/|_| |_|\\___|_|_|\\____\\__,_|___/\\__|

                Playback started
    EOH

    FOOTER = <<-EOF
     _   _                           _ 
    | |_| |__   ___    ___ _ __   __| |
    | __| '_ \\ / _ \\  / _ \\ '_ \\ / _` |
    | |_| | | |  __/ |  __/ | | | (_| |
     \\__|_| |_|\\___|  \\___|_| |_|\\__,_|
    EOF


    def self.play(id)
      new(id).play
    end

    def self.list
      Dir[File.join(ShellCast::DATA_DIR, "**", 'meta')].each do |path|
        metadata = YAML.load_file(path)
        puts "#{metadata["id"]}: #{metadata["title"]}"
      end
    end

    def initialize(id)
      @shellcast_id = id
    end

    def play
      puts HEADER.red_on_white
      puts
      system(scriptreplay_cmd)
      puts
      puts FOOTER.red_on_white
    end

    private

    def shellcast_file(name)
      File.join(ShellCast.shellcast_dir(@shellcast_id), name)
    end

    def scriptreplay_cmd
      "scriptreplay #{shellcast_file('timing')} #{shellcast_file('data')}"
    end
  end
end
