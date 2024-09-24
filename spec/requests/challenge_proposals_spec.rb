require 'rails_helper'
require 'omniauth/test'
require 'webmock/rspec'
WebMock.allow_net_connect!

RSpec.describe "ChallengeProposals", type: :request do
  before do
    OmniAuth.config.test_mode = true

    # Imposta una risposta mock per OmniAuth
    OmniAuth.config.mock_auth[:auth0] = OmniAuth::AuthHash.new({
      'uid' => 'auth0|1234567890',
      'info' => {
        'email' => 'example@gmail.com',
        'name' => 'Test User',
        'password' => 'Password1!'

      }
    })

    @user = RegisteredUser.create!(email: 'example@gmail.com', username: 'test_user', auth0_id: 'auth0|12345', password:'Password1')
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    # Ottieni i valori delle variabili di ambiente
    client_id = ENV['AUTH0_CLIENT_ID']
    client_secret = ENV['AUTH0_CLIENT_SECRET']

    # Stub per la richiesta POST all'endpoint Auth0
    stub_request(:post, "https://dev-q2ndxlj8aowxx2uj.us.auth0.com/oauth/token")
      .with(
        body: {
          client_id: client_id,
          client_secret: client_secret,
          grant_type: "client_credentials",
          audience: "https://dev-q2ndxlj8aowxx2uj.us.auth0.com/api/v2/"
        }.to_json,
        headers: {
          'Accept' => '*/*',
          'Content-Type' => 'application/json'
        }
      )
      .to_return(status: 200, body: { "access_token": "mock_access_token" }.to_json, headers: { 'Content-Type' => 'application/json' })

    # Stub per la richiesta GET all'endpoint utenti Auth0
    stub_request(:get, "https://dev-q2ndxlj8aowxx2uj.us.auth0.com/api/v2/users/auth0%7C1234567890")
      .with(
        headers: {
          'Accept' => '*/*',
          'Authorization' => 'Bearer mock_access_token',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: 200, body: '{"email": "example@gmail.com", "name": "Test User"}', headers: { 'Content-Type' => 'application/json' })
  end

  after do
    OmniAuth.config.test_mode = false
  end

  describe "GET /new" do
    it "returns http success" do
      get "/challenge_proposals/new"
      expect(response).to have_http_status(:success)
    end
  end

end
