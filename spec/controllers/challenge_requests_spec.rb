require 'rails_helper'

RSpec.describe ChallengeRequestsController, type: :controller do
  let!(:user) { User.create!(username: 'test_user', email: 'test@example.com', password: 'password') }
  let!(:friend) { User.create!(username: 'friend_user', email: 'friend@example.com', password: 'password') }

  before do
    session[:user_id] = user.id
  end

  describe 'GET #index' do
    it 'assegna le richieste di sfida ricevute e inviate' do
      challenge_request_sent = ChallengeRequest.create!(user_id: user.id, friend_id: friend.id, language: 'Ruby')
      challenge_request_received = ChallengeRequest.create!(user_id: friend.id, friend_id: user.id, language: 'Python')

      get :index
      expect(assigns(:received_challenge_requests)).to include(challenge_request_received)
      expect(assigns(:sent_challenge_requests)).to include(challenge_request_sent)
      expect(response).to have_http_status(:ok)
    end

    it 'assegna una lista vuota se non ci sono sfide' do
      get :index
      expect(assigns(:received_challenge_requests)).to be_empty
      expect(assigns(:sent_challenge_requests)).to be_empty
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    it 'crea una nuova richiesta di sfida' do
      post :create, params: { friend_id: friend.id, language: 'Ruby' }
      challenge_request = ChallengeRequest.last
      expect(challenge_request.user_id).to eq(user.id)
      expect(challenge_request.friend_id).to eq(friend.id)
      expect(challenge_request.language).to eq('Ruby')
      expect(response).to redirect_to(root_path)
     end

    it 'fallisce quando i parametri sono incompleti' do
      post :create, params: { friend_id: nil, language: 'Ruby' }
      expect(response).to redirect_to(root_path)
   end
  end

  describe 'POST #accept' do
    let!(:challenge_proposal) { ChallengeProposal.create!(user: user, title: 'Test Proposal', test_cases: 'test', description: 'Test description', language: 'Python') }
    let!(:challenge) { Challenge.create!(title: "test title", description: 'test description', language: 'Python', challenge_proposal: challenge_proposal) }
    let!(:challenge_request) { ChallengeRequest.create!(user_id: friend.id, friend_id: user.id, language: 'Python') }

    it 'accetta la sfida e crea un match' do
      post :accept, params: { id: challenge_request.id }

      match = Match.last
      expect(match.player_1_id).to eq(friend.id)
      expect(match.player_2_id).to eq(user.id)
      expect(match.language).to eq('Python')
      expect(match.status).to eq('ongoing')

      expect(ChallengeRequest.find_by(id: challenge_request.id)).to be_nil
      expect(response).to redirect_to(match_path(match.id))
    end
  end

  describe 'POST #reject' do
    let!(:challenge_request) { ChallengeRequest.create!(user_id: friend.id, friend_id: user.id, language: 'Python') }

    it 'rifiuta la richiesta di sfida' do
      post :reject, params: { id: challenge_request.id }
      expect(ChallengeRequest.find_by(id: challenge_request.id)).to be_nil
      expect(response).to redirect_to(root_path)
    end
  end
end
