require 'rails_helper'
require 'webmock/rspec'

RSpec.describe MatchesController, type: :controller do
  before do
    # Mock the JDoodle API request
    stub_request(:post, "https://api.jdoodle.com/v1/execute").
      with(
        body: {
          clientId: ENV["JDOODLE_CLIENT_ID"],
          clientSecret: ENV["JDOODLE_CLIENT_SECRET"],
          script: "Hello, World!",
          language: "python3",
          versionIndex: "0"
        }.to_json,
        headers: {
          'Accept' => '*/*',
          'Content-Type' => 'application/json',
          'User-Agent' => 'Ruby'
        }).
      to_return(status: 200, body: {output: "Hello, World!"}.to_json)

    OmniAuth.config.test_mode = true

    # Imposta una risposta mock per OmniAuth
    OmniAuth.config.mock_auth[:auth0] = OmniAuth::AuthHash.new({
      'uid' => 'auth0|1234567890',
      'info' => {
        'email' => 'test@example.com',
        'name' => 'Test User'
      }
    })

    # Crea due utenti
    @user1 = User.create!(email: "test1@example.com", auth0_id: 'auth0|1234567890')
    @user2 = User.create!(email: "test2@example.com", auth0_id: 'auth0|0987654321')

    # Crea un match
    @match = Match.create!(player_1: @user1, player_2: @user2)

    # Crea un challenge per testare
    @challenge = Challenge.create!(language: 'python3', title: 'Sample Challenge', description: 'Test Challenge')

    # Usa un utente per il test
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
  end

  describe 'POST #run_code' do
    let(:valid_attributes) do
      {
        match_id: @match.id,
        script: "Hello, World!",
        language: "python3",
        versionIndex: "0"
      }
    end

    it 'loads the result into the console element' do
      post :run_code, params: valid_attributes

      # Aggiungi il debug per vedere cosa viene restituito
      puts response.body

      # Verifica che la risposta sia quella attesa
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Hello, World!')
    end
  end
end

