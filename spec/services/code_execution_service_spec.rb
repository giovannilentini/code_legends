require 'rails_helper'

RSpec.describe CodeExecutionService, type: :service do
  describe '.execute_code' do
    let(:script) { 'print("Hello, world!")' }
    let(:language) { 'python3' }
    let(:url) { 'https://code-compiler.p.rapidapi.com/v2' }
    let(:response_body) { { 'status' => 'success', 'result' => 'Hello, world!' }.to_json }
    let(:response) { instance_double(Net::HTTPResponse, read_body: response_body) }

    before do
      # Mock the external HTTP request
      stub_request(:post, url)
        .with(
          body: { LanguageChoice: 5, Program: script }.to_json,
          headers: {
            'Content-Type' => 'application/json',
            'x-rapidapi-key' => 'eefc520438msh4f066a4a8f37622p18beeajsn0405e20bec87',
            'x-rapidapi-host' => 'code-compiler.p.rapidapi.com'
          }
        )
        .to_return(status: 200, body: response_body, headers: {})
    end

    it 'sends a POST request with the correct parameters and headers' do
      CodeExecutionService.execute_code(script, language)

      expect(WebMock).to have_requested(:post, url)
                           .with(
                             body: { LanguageChoice: 5, Program: script }.to_json,
                             headers: {
                               'Content-Type' => 'application/json',
                               'x-rapidapi-key' => 'eefc520438msh4f066a4a8f37622p18beeajsn0405e20bec87',
                               'x-rapidapi-host' => 'code-compiler.p.rapidapi.com'
                             }
                           ).once
    end

    it 'returns the response from the API' do
      result = CodeExecutionService.execute_code(script, language)

      expect(result.read_body).to eq(response_body)
    end
  end
end