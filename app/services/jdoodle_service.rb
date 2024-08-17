class JdoodleService
  require 'net/http'
  require 'json'

  BASE_URL = 'https://api.jdoodle.com/v1/execute'

  def self.execute_code(script, language)
    req_params = {:clientId => ENV['JDOODLE_CLIENT_ID'], :clientSecret => ENV['JDOODLE_CLIENT_SECRET'],
              :script => script, :language => language, :versionIndex => '0'
    }
    uri = URI(BASE_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, 'Content-Type' => 'application/json')
    request.body = req_params.to_json
    response = http.request(request)
    return response
  end
end