require 'rails_helper'

RSpec.describe MatchesController, type: :controller do
  let(:user1) { User.create(email: 'user1@example.com', guest: false, password: 'password') }
  let(:user2) { User.create(email: 'user2@example.com', guest: false, password: 'password') }
  let(:challenge_proposal) { ChallengeProposal.create(title: 'Challenge Proposal', description: 'Proposal description', test_cases:"asdasd", user: user1) }
  let(:challenge) { Challenge.create(title: 'Challenge', description: 'Challenge description', challenge_proposal: challenge_proposal) }
  let!(:match) { Match.create!(player_1: user1, player_2: user2, challenge: challenge, status: 'ongoing') }

  before do
    # Simula l'accesso dell'utente
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)
    allow_any_instance_of(ApplicationController).to receive(:user_signed_in?).and_return(true)
  end

  describe 'GET #show' do
    context 'when match is not finished' do
      it 'renders the show template if the current user is a participant' do
        get :show, params: { id: match.id }
        expect(response).to have_http_status(:success)
      end

      it 'redirects to root with an alert if the current user is not a participant' do
        other_user = User.create(email: 'other_user@example.com', guest: false, password: 'password')
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(other_user)
        get :show, params: { id: match.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to view this match.')
      end
    end

    context 'when match is finished' do
      before { match.update(status: 'finished') }

      it 'redirects to root with an alert' do
        get :show, params: { id: match.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Match finished')
      end
    end
  end

  describe 'POST #execute_code' do
  let(:code_execution_service) { double('CodeExecutionService') }
  let(:success_response) { { "Result" => "Winner", "Errors" => "" }.to_json }
  let(:error_response) { { "Result" => nil, "Errors" => "Some error" }.to_json }
  

  before do
    allow(CodeExecutionService).to receive(:execute_code).and_return(double(body: success_response))
    allow(LeaderboardService).to receive(:update_score)
  end

  it 'executes code and returns result' do
    post :execute_code, params: { id: match.id, code: 'some_code', language: 'ruby' }
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)['output']).to eq('Winner')
  end

  context 'when result indicates a win' do
    it 'sets the winner and updates match status' do
      expect_any_instance_of(MatchesController).to receive(:set_winner).with(user1, user2, match).and_call_original
      post :execute_code, params: { id: match.id, code: 'some_code', language: 'ruby' }
    end
 
    it 'updates the leaderboard when the result indicates a win' do
      post :execute_code, params: { id: match.id, code: 'some_code', language: 'ruby' }
      expect(LeaderboardService).to have_received(:update_score).twice
    end
  end

  context 'when there are errors in the response' do
    before do
      allow(CodeExecutionService).to receive(:execute_code).and_return(double(body: error_response))
    end

    it 'returns error message if there are errors' do
      post :execute_code, params: { id: match.id, code: 'some_code', language: 'ruby' }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['output']).to eq('Some error')
    end
  end
end


  describe 'POST #surrender' do
  let(:code_execution_service) { double('CodeExecutionService') }
  

  before do
    allow(controller).to receive(:current_user).and_return(user1)
    allow_any_instance_of(MatchesController).to receive(:set_winner).with(user2, user1, match, true)
    
    

    match.update(status: 'ongoing')
  end

  it 'finishes the match and updates the winner' do
    post :surrender, params: { id: match.id }
    expect(response).to have_http_status(:success)
    # Verifica lo stato del match
    match.reload
    expect(match.status).to eq('finished')
  end

  it 'does nothing if the match is already finished' do
    match.update(status: 'finished')
    post :surrender, params: { id: match.id }
    expect(match.reload.status).to eq('finished')
  end
end

describe 'POST #timeout' do
  before do
    match.update(timer_expires_at: 1.minute.ago)
  end

  it 'finishes the match with a draw if the timer has expired' do
    post :timeout, params: { match_id: match.id }
    expect(response).to have_http_status(:ok)
    expect(match.reload.status).to eq('finished')
  end
  

  it 'does nothing if the match is already finished' do
    match.update(status: 'finished')
    post :timeout, params: { match_id: match.id }
    expect(match.reload.status).to eq('finished')
  end
  
  it 'does nothing if the timer has not expired' do
    match.update(timer_expires_at: 1.minute.from_now)
    post :timeout, params: { match_id: match.id }
    expect(match.reload.status).to eq('ongoing')
  end
  end
end


