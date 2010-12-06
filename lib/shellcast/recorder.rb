module ShellCast
  class Recorder

    def self.record!
      new.record!
    end

    def initialize
      @meta = {}
    end

    def record!
      FileUtils.mkdir_p(shellcast_dir) unless File.exists?(shellcast_dir)
      request_metadata
      puts "Your session started"
      puts "Type Ctrl+D or exit to finish recording"
      puts "-" * 80
      init_terminal
      system(script_cmd)
      restore_terminal
      puts "-" * 80
      puts "Session finihed!"
      puts "Shellcast ID:\t #{shellcast_id}"
      puts "Shellcast path:\t #{shellcast_dir}"
    end

    def request_metadata
      puts "Provide name for Your shellcast: "
      @meta["title"] = STDIN.gets.strip
      @meta["id"] = shellcast_id
      puts shellcast_file('meta')
      File.open(shellcast_file('meta'), 'w+') do |meta|
        meta.puts @meta.to_yaml
      end
    end

    private

    def init_terminal
      stty_data = `stty -a`
      @user_columns = stty_data.match(/columns (\d+)/)[1]
      @user_rows    = stty_data.match(/rows (\d+)/)[1]
      puts "Saved terminal size #{@user_columns}X#{@user_rows}"
      system("stty columns 80 rows 24")
    end

    def restore_terminal
      system("stty columns #{@user_columns} rows #{@user_rows}")
    end

    def shellcast_dir
      @shellcast_dir ||= ShellCast.shellcast_dir(shellcast_id)
    end

    def shellcast_id
      @shellcast_id  ||= Time.now.to_i.to_s
    end

    def shellcast_file(name)
      File.join(ShellCast.shellcast_dir(shellcast_id), name)
    end

    def script_cmd
      "script -c 'bash' #{shellcast_file('data')} -t 2> #{shellcast_file('timing')}"
    end
  end
end
