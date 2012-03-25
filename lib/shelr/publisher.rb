require 'net/http'
require 'uri'

module Shelr
  class Publisher

    def publish(id)
      with_exception_handler do
        uri = URI.parse(Shelr::API_URL + '/records')
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
        puts "=> record dumped to #{dump_filename}"
      end
    end

    private

    def with_exception_handler(&block)
      yield
    rescue => e
      puts "=> Something went wrong..."
      puts e.message
      puts e.backtrace.join("\n")
    end

    def handle_response(res)
      res = JSON.parse(res.body)
      if res['ok']
        puts res['message']
        puts Shelr::API_URL + '/records/' + res['id']
      else
        puts res['message']
      end
    end

    def dump_filename
      File.join(Dir.getwd, 'shelr-record.json')
    end

    def api_key
      unless Shelr.api_key
        print 'Paste your API KEY [or Enter to publish as Anonymous]: '
        key = STDIN.gets.strip
        Shelr.api_key = key unless key.empty?
      end
      Shelr.api_key
    end

    def prepare(id)
      puts
      puts 'Your record will be published under terms of'
      puts 'Creative Commons Attribution-ShareAlike 3.0 Unported'
      puts 'See http://creativecommons.org/licenses/by-sa/3.0/ for details.'
      puts

      out = {}
      ['meta', 'timing', 'typescript'].each do |file|
        out[file] = File.read(File.join(Shelr.data_dir(id), file))
      end

      meta = JSON.parse(out.delete('meta'))
      meta.each { |k,v| out[k] = v }
      print 'Description: '
      out['description'] = STDIN.gets.strip
      print 'Tags (ex: howto, linux): '
      out['tags'] = STDIN.gets.strip
      return out.to_json
    end
  end
end
