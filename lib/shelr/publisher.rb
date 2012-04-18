require 'net/http'
require 'uri'

module Shelr
  class Publisher

    def publish(id, priv = false)
      @private = priv
      ensure_unlocked(id)
      with_exception_handler do
        uri = URI.parse(Shelr.api_url + '/records')
        params = { 'record' => prepare(id) }
        params.merge!({'api_key' => Shelr.api_key}) if api_key
        handle_response Net::HTTP.post_form(uri, params)
      end
    end

    def dump(id)
      with_exception_handler do
        File.open(dump_filename, 'w+') do |f|
          f.puts(prepare(id))
        end
        STDOUT.puts "=> record dumped to #{dump_filename}"
      end
    end

    private

    def ensure_unlocked(id)
      lock_path = File.join(Shelr.data_dir(id), 'lock')
      if File.exist?(lock_path)
        puts "=> Cannot publish the record (make sure it finished with exit or Ctrl+D)"
        puts "=> Record locked on #{File.read(lock_path)}"
        puts "=> Make sure no other shelr process running (ps axu | grep shelr)"
        puts "=> Or remove lock file manually: #{lock_path}"
        exit 0
      end
    end

    def with_exception_handler(&block)
      yield
    rescue => e
      STDOUT.puts "=> Something went wrong..."
      STDOUT.puts e.message
      STDOUT.puts e.backtrace.join("\n")
    end

    def handle_response(res)
      with_exception_handler do
        res = JSON.parse(res.body)
        if res['ok']
          STDOUT.puts "=> " + res['message'].to_s
          STDOUT.puts "=> " + res['url'].to_s
        else
          STDOUT.puts res['message']
        end
      end
    end

    def dump_filename
      File.join(Dir.getwd, 'shelr-record.json')
    end

    def api_key
      unless Shelr.api_key
        STDOUT.print 'Paste your API KEY [or Enter to publish as Anonymous]: '
        key = STDIN.gets.strip
        Shelr.api_key = key unless key.empty?
      end
      Shelr.api_key
    end

    def prepare(id)
      STDOUT.puts
      STDOUT.puts 'Your record will be published under terms of'
      STDOUT.puts 'Creative Commons Attribution-ShareAlike 3.0 Unported'
      STDOUT.puts 'See http://creativecommons.org/licenses/by-sa/3.0/ for details.'
      STDOUT.puts

      out = {}
      ['meta', 'timing', 'typescript'].each do |file|
        out[file] = File.read(File.join(Shelr.data_dir(id), file))
      end

      meta = JSON.parse(out.delete('meta'))
      meta.each { |k,v| out[k] = v }
      STDOUT.print 'Description: '
      out['description'] = STDIN.gets.strip
      STDOUT.print 'Tags (ex: howto, linux): '
      out['tags'] = STDIN.gets.strip
      out['private'] = @private
      return out.to_json
    end
  end
end
