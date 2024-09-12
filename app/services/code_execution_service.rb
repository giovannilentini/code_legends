class CodeExecutionService
  require 'net/http'
  require 'json'
  def self.execute_code(script, language)
    chosen_language = 0
    if language == "python3"
      chosen_language = 5
    elsif language == "java"
      chosen_language = 4
    elsif language == "cpp"
      chosen_language = 7
    else

    end

    req_params = {:LanguageChoice=> chosen_language, :Program => script}
    url = URI("https://code-compiler.p.rapidapi.com/v2")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["x-rapidapi-key"] = 'eefc520438msh4f066a4a8f37622p18beeajsn0405e20bec87'
    request["x-rapidapi-host"] = 'code-compiler.p.rapidapi.com'
    request["Content-Type"] = 'application/json'
    request.body = req_params.to_json
    response = http.request(request)
    p response.read_body
    return response
  end

end