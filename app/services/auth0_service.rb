class Auth0Service
  require 'uri'
  require 'net/http'

  @domain = Rails.application.credentials.auth0_api['auth0_domain']
  def self.get_user_info(user_id)
    token = get_token
    encoded_user_id = URI.encode_www_form_component(user_id)
    uri = URI.parse("https://#{@domain}/api/v2/users/#{encoded_user_id}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri)
    request["authorization"] = "Bearer #{token}"

    response = http.request(request)
    unless response.nil?
      if response.code == "200"
        JSON.parse(response.body)
      else
        JSON.parse(response.body)["error"]
      end
    end
  end
  def self.get_users
    token = get_token
    uri = URI("https://#{@domain}/api/v2/users?fields=email%2Cuser_id%2Cnickname%2Cusername&include_fields=true")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri)
    request["authorization"] = "Bearer #{token}"

    response = http.request(request)
    unless response.nil?
      if response.code == "200"
        JSON.parse(response.body)
      else
        JSON.parse(response.body)["error"]
      end
    end
  end
  private
  def self.get_token
    url = URI("https://#{@domain}/oauth/token")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'application/json'
    request.body = {client_id: Rails.application.credentials.auth0_api["auth0_management_id"],
                    client_secret: Rails.application.credentials.auth0_api["auth0_management_secret"],
                    grant_type: "client_credentials",
                    audience: "https://#{@domain}/api/v2/"}.to_json
    response = http.request(request)
    return JSON.parse(response.body)["access_token"]
  end
end