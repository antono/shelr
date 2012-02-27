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
      puts HEADER
      puts "Your session started"
      puts "Type Ctrl+D or exit to finish recording"
      system(recorder_cmd)
      restore_terminal
      save_as_typescript if Shelr.backend == 'ttyrec'
      puts FOOTER
      puts
      puts "Replay  : #{Shelr::APP_NAME} play last"
      puts "Publish : #{Shelr::APP_NAME} push last"
    end

    def request_metadata
      init_terminal
      print "Provide HUMAN NAME for Your record: "
      @meta["title"] = STDIN.gets.strip
      @meta["created_at"] = record_id
      @meta["columns"] = @user_columns
      @meta["rows"] = @user_rows
      puts record_file('meta')
      File.open(record_file('meta'), 'w+') do |meta|
        meta.puts @meta.to_json
      end
    end

    private

    def save_as_typescript
      puts '=> Converting ttyrec -> typescript'

      ttyrecord  = File.open(record_file('ttyrecord'), 'r')
      converter  = Shelr::TTYRec.new(ttyrecord)
      typescript = converter.parse.to_typescript

      [:typescript, :timing].each do |part|
        File.open(record_file(part.to_s), 'w') do |f|
          f.write(typescript[part])
        end
      end
    end

    def check_record_dir
      FileUtils.mkdir_p(record_dir) unless File.exists?(record_dir)
    end

    def init_terminal
      term_info = `infocmp`
      @user_columns = term_info.match(/cols#(\d+)/)[1]
      @user_rows    = term_info.match(/lines#(\d+)/)[1]
    end

    def restore_terminal
      # system("stty columns #{@user_columns} rows #{@user_rows}")
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

    def recorder_cmd
      case Shelr.backend
      when 'script'
        "script #{record_file('typescript')} -t 2> #{record_file('timing')}"
      when 'ttyrec'
        "ttyrec #{record_file('ttyrecord')}"
      end
    end
  end
end
