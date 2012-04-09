# encoding: utf-8
module Shelr
  class Recorder

    attr_accessor :meta, :user_rows, :user_columns

    def self.record!
      new.record!
    end

    def initialize
      @meta = {}
    end

    def record!
      check_record_dir
      with_lock_file do
        init_terminal
        request_metadata
        Shelr.terminal.puts_line
        STDOUT.puts "=> Your session started"
        STDOUT.puts "=> Please, do not resize your terminal while recording"
        STDOUT.puts "=> Press Ctrl+D or 'exit' to finish recording"
        system(recorder_cmd)
        save_as_typescript if Shelr.backend == 'ttyrec'
        Shelr.terminal.puts_line
        STDOUT.puts "=> Session finished"
        STDOUT.puts
        STDOUT.puts "Replay  : #{Shelr::APP_NAME} play last"
        STDOUT.puts "Publish : #{Shelr::APP_NAME} push last"
      end
    end

    def request_metadata
      STDOUT.print "Provide some title for your record: "
      @meta["title"] = STDIN.gets.strip
      @meta["recorded_at"] = record_id
      @meta["columns"] = @user_columns
      @meta["rows"] = @user_rows
      @meta["uname"] = `uname -a`
      @meta["shell"] = ENV['SHELL']
      @meta["term"] = ENV['TERM']
      STDOUT.puts record_file('meta')
      File.open(record_file('meta'), 'w+') do |meta|
        meta.puts @meta.to_json
      end
    end

    private

    def with_lock_file
      lock_path = record_file('lock')
      File.open(lock_path, 'w') do |f|
        f.puts Time.now.to_s
      end
      yield
      FileUtils.rm(lock_path)
    end

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
      @user_rows, @user_columns =
        Shelr.terminal.size[:height], Shelr.terminal.size[:width]
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
