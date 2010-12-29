require 'oauth'
require 'net/http'
require 'uri'

module ShellCast
  class Publisher

    API_URL = 'http://localhost:3000'

    def publish(id)
      uri = URI.parse(API_URL + '/records')
      res = Net::HTTP.post_form(uri,  prepare(id))
      # TODO process
      # TODO stamp as published
    end

    def prepare(id)
      out = {}
      ['meta', 'timing', 'data'].each do |file|
        out[file] = File.read(File.join(ShellCast.shellcast_dir(id), file))
      end
      return out
    end

    private

    def access_token
      @access_token = OAuth::AccessToken.new(consumer)
    end

    def consumer
      @consumer ||= OAuth::Consumer.new(oauth_credentails['key'],
                                        oauth_credentails['secret'],
                                        :site => API_URL,
                                        :request_token_path => "/oauth/request_token",
                                        :authorize_path => "/oauth/authorize",
                                        :access_token_path => "/oauth/access_token",
                                        :http_method => :get)
    end

    def oauth_credentails
      @credentails ||= YAML.load_file(File.join(ShellCast::CONFIG_DIR, 'oauth.yml'))
    end
  end
end
