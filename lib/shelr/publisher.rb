require 'net/http'
require 'uri'

module Shelr
  class Publisher

    def publish(id)
      uri = URI.parse(Shelr::API_URL + '/records')
      params = { 'record' =>  prepare(id) }
      params.merge!({'api_key' => Shelr.api_key}) if api_key
      res = Net::HTTP.post_form(uri, params)
      res = JSON.parse(res.body)
      if res['ok']
        puts res['message']
        puts Shelr::API_URL + '/records/' + res['id']
      else
        puts res['message']
      end
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
      puts 'Your record will be published under terms of Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0)'
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
