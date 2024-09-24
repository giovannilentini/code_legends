require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Auth0Service, type: :service do
  let(:auth0_domain) { Rails.application.credentials.auth0_api['auth0_domain'] }
  let(:auth0_token) { "mocked_auth0_token" }

  before do
    allow(Auth0Service).to receive(:get_token).and_return(auth0_token)
  end

  describe '.get_user_info' do
    it 'retrieves user information successfully' do
      user_id = 'auth0|12345'
      stub_request(:get, "https://#{auth0_domain}/api/v2/registered_users/#{user_id}")
        .with(headers: { 'Authorization' => "Bearer #{auth0_token}" })
        .to_return(status: 200, body: { username: 'testuser', email: 'example@gmail.com' }.to_json, headers: {})

      user_info = Auth0Service.get_user_info(user_id)
      expect(user_info['username']).to eq('testuser')
      expect(user_info['email']).to eq('example@gmail.com')
    end

    it 'returns error message when user not found' do
      user_id = 'auth0|nonexistent'
      stub_request(:get, "https://#{auth0_domain}/api/v2/registered_users/#{user_id}")
        .with(headers: { 'Authorization' => "Bearer #{auth0_token}" })
        .to_return(status: 404, body: { error: 'user not found' }.to_json, headers: {})

      user_info = Auth0Service.get_user_info(user_id)
      expect(user_info).to eq('user not found')
    end
  end

  describe '.get_users' do
    it 'retrieves the list of registered_users successfully' do
      stub_request(:get, "https://#{auth0_domain}/api/v2/registered_users?fields=email%2Cuser_id%2Cnickname%2Cusername&include_fields=true")
        .with(headers: { 'Authorization' => "Bearer #{auth0_token}" })
        .to_return(status: 200, body: [{ email: 'example@gmail.com', username: 'testuser' }].to_json, headers: {})

      users = Auth0Service.get_users
      expect(users.first['email']).to eq('example@gmail.com')
      expect(users.first['username']).to eq('testuser')
    end

    it 'returns error message if request fails' do
      stub_request(:get, "https://#{auth0_domain}/api/v2/registered_users?fields=email%2Cuser_id%2Cnickname%2Cusername&include_fields=true")
        .with(headers: { 'Authorization' => "Bearer #{auth0_token}" })
        .to_return(status: 500, body: { error: 'internal server error' }.to_json, headers: {})

      users = Auth0Service.get_users
      expect(users).to eq('internal server error')
    end
  end
end
