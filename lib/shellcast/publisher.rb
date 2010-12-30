require 'net/http'
require 'uri'

module ShellCast
  class Publisher

    API_URL = ENV['SC_LOCAL'] ? 'http://localhost:3000' : 'http://shell.heroku.com'

    def publish(id)
      uri = URI.parse(API_URL + '/records')
      params = { 'record' =>  prepare(id) }
      params.merge!({'api_key' => ShellCast.api_key}) if api_key
      res = Net::HTTP.post_form(uri, params)
      res = JSON.parse(res.body)
      if res['ok']
        puts res['message']
        puts API_URL + '/records/' + res['id']
      else
        puts res['message']
      end
    end

    def api_key
      unless ShellCast.api_key
        print 'Paste your API KEY [or Enter to publish as Anonymous]: '
        key = STDIN.gets.strip
        ShellCast.api_key = key unless key.empty?
      end
      ShellCast.api_key
    end

    def prepare(id)
      out = {}
      ['meta', 'timing', 'typescript'].each do |file|
        out[file] = File.read(File.join(ShellCast.shellcast_dir(id), file))
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
