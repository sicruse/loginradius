#
# Ruby Helper Class for Janrain Engage
#
require 'rubygems'
require 'cgi'
require 'uri'
require 'net/http'
require 'net/https'
require 'json'

module LoginRadius
  
  class LoginRadiusException < StandardError
    attr_reader :http_response
    def initialize(http_response)
      @http_response = http_response
    end
  end
    
  class LoginRadiusSession
    attr_reader :api_key, :base_url, :data
    
    def initialize(api_key, base_url = "http://hub.loginradius.com")
      @api_key = api_key
      @base_url = base_url.sub(/\/*$/, '')
      @data = ""
    end
    
    def authenticate_token?(token, id)
      @data = api_call 'userprofile', :token => token
      result = (@data['ID'].to_s == id.to_s)
    end

    private
        
    def api_call(method_name, partial_query)
      query = partial_query.dup
      query['apisecrete'] = @api_key
      
      data = query.map { |k,v|
        "#{CGI::escape k.to_s}=#{CGI::escape v.to_s}"
      }.join('&')
      
      path = "#{@base_url}/#{method_name}.ashx/?" + data
      url = URI.parse(path)
      
      http = Net::HTTP.new(url.host, url.port)
      if url.scheme == 'https'
        http.use_ssl = true
      end

      resp = Net::HTTP.get_response(URI.parse(path))

      if resp.response.code == '200'
        begin
          data = JSON.parse(resp.response.body)
        rescue JSON::ParserError => err
          raise LoginRadiusRException.new(resp.response), 'LoginRadiusSession: Unable to parse JSON response'
        end
      else
        raise LoginRadiusException.new(resp.response), "LoginRadiusSession: Unexpected HTTP status code from server: #{resp.response.code}"
      end

      return data
    end
  end
    
end