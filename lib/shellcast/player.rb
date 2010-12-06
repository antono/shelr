module ShellCast
  class Player
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
      puts ""
      puts "Playback started"
      puts "-" * 80
      system(scriptreplay_cmd)
      puts
      puts "-" * 80
      puts "Playback finished"
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
