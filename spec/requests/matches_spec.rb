require 'rails_helper'


RSpec.describe 'Matches', type: :request do
  let(:user1) { User.create!(email: 'user1@example.com', guest: false, password: 'password') }
  let(:user2) { User.create!(email: 'user2@example.com', guest: false, password: 'password') }
  let(:challenge_proposal) { ChallengeProposal.create!(user: user1, title: 'Test Challenge', test_cases: "asuyidgas", description: 'A challenging challenge') }
  let(:challenge) { Challenge.create!(title: 'Test Challenge', difficulty: "easy",  description: 'A challenging challenge', challenge_proposal: challenge_proposal) }
  let(:match) { Match.create!(player_1_id: user1.id, player_2_id: user2.id, challenge: challenge, status: "ongoing", timer_expires_at: 10.minutes.from_now) }

  before do
    # Manually set the current user for authorization
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)
  end

  describe 'GET /matches/:id' do
    it 'shows a match' do
      get "/matches/#{match.id}"
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /matches/:id/execute_code' do
    it 'executes code for the match' do
      stub_request(:post, "https://code-compiler.p.rapidapi.com/v2").
        with(
          body: "{\"LanguageChoice\":5,\"Program\":\"Hello, world!\"}",
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type'=>'application/json',
            'Host'=>'code-compiler.p.rapidapi.com',
            'User-Agent'=>'Ruby',
            'X-Rapidapi-Host'=>'code-compiler.p.rapidapi.com',
            'X-Rapidapi-Key'=>'eefc520438msh4f066a4a8f37622p18beeajsn0405e20bec87'
          }).
        to_return(status: 200, body: {Result: "Code executed", Errors: nil}.to_json, headers: {})
      post "/matches/#{match.id}/execute_code", params: { code: "Hello, world!", language: "python3" }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("{\"output\":\"Code executed\"}")
    end
  end

  describe 'POST /matches/:id/surrender' do
    it 'surrenders the match' do
      post "/matches/#{match.id}/surrender"

      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'POST /matches/:id/timeout' do
    it 'handles a match timeout' do
      post "/matches/#{match.id}/timeout"

      expect(response).to have_http_status(:ok)
    end
  end
end
