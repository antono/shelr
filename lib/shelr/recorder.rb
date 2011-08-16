# encoding: utf-8
module Shelr
  class Recorder

    HEADER = <<-EOH
 ____                        _ _             
|  _ \ ___  ___ ___  _ __ __| (_)_ __   __ _ 
| |_) / _ \/ __/ _ \| '__/ _` | | '_ \ / _` |
|  _ <  __/ (_| (_) | | | (_| | | | | | (_| |
|_| \_\___|\___\___/|_|  \__,_|_|_| |_|\__, |
                                       |___/ 
    EOH

    FOOTER = <<-EOF
 _____ _       _     _              _ 
|  ___(_)_ __ (_)___| |__   ___  __| |
| |_  | | '_ \| / __| '_ \ / _ \/ _` |
|  _| | | | | | \__ \ | | |  __/ (_| |
|_|   |_|_| |_|_|___/_| |_|\___|\__,_|
                                      
    EOF

    def self.record!
      new.record!
    end

    def initialize
      @meta = {}
    end

    def record!
      check_record_dir
      request_metadata
      puts HEADER.black_on_white
      puts "Your session started"
      puts "Type Ctrl+D or exit to finish recording"
      init_terminal
      system(script_cmd)
      restore_terminal
      puts FOOTER.black_on_white
      puts "hint $ #{Shelr::APP_NAME} play #{record_id}".green
    end

    def request_metadata
      print "Provide HUMAN NAME for Your shellcast: "
      @meta["title"] = STDIN.gets.strip
      @meta["created_at"] = record_id
      puts record_file('meta')
      File.open(record_file('meta'), 'w+') do |meta|
        meta.puts @meta.to_json
      end
    end

    private

    def check_record_dir
      FileUtils.mkdir_p(record_dir) unless File.exists?(record_dir)
    end

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

    def record_dir
      @record_dir ||= Shelr.data_dir(record_id)
    end

    def record_id
      @record_id ||= Time.now.to_i.to_s
    end

    def record_file(name)
      File.join(Shelr.data_dir(record_id), name)
    end

    def script_cmd
      "script -c 'bash' #{record_file('typescript')} -t 2> #{record_file('timing')}"
    end
  end
end
