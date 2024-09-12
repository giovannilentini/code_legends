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
      it 'renders the show template' do
        get :show, params: { id: match.id }
        expect(response).to have_http_status(:success)
      end

      it 'redirects if the current user is not a participant' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user2)
        get :show, params: { id: match.id }
        expect(response).to have_http_status(:success)
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
    let(:response_body) { { "Result" => "Winner", "Errors" => "" }.to_json }

    before do
      allow(CodeExecutionService).to receive(:execute_code).and_return(double(body: response_body))
    end

    it 'executes code and returns result' do
      post :execute_code, params: { id: match.id, code: 'some_code', language: 'ruby' }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['output']).to eq('Winner')
    end

    context 'when result indicates a win' do
      it 'sets the winner and updates match status' do
        expect_any_instance_of(MatchesController).to receive(:set_winner).with(user1, user2, match)
        post :execute_code, params: { id: match.id, code: 'some_code', language: 'ruby' }
      end
    end
  end

  describe 'POST #surrender' do
  before do
    # Mocking current_user and set_winner
    allow(controller).to receive(:current_user).and_return(user1)
    allow_any_instance_of(MatchesController).to receive(:set_winner).with(user2, user1, match, true)
    # Assicurati che il match sia nella situazione di test corretta
    match.update(status: 'ongoing')
  end

  it 'finishes the match and updates the winner' do
    post :surrender, params: { id: match.id }
    expect(response).to have_http_status(:success)
    # Verifica lo stato del match
    match.reload
    expect(match.status).to eq('finished')
  end
end

describe 'POST #timeout' do
  before do
    # Imposta una condizione in cui il timer è scaduto
    match.update(timer_expires_at: 1.minute.ago)
  end

  it 'finishes the match with a draw if the timer has expired' do
    post :timeout, params: { match_id: match.id }
    expect(response).to have_http_status(:ok)
    expect(match.reload.status).to eq('finished')
    # Verifica anche il broadcasting se configurato
  end

  it 'does nothing if the match is already finished' do
    match.update(status: 'finished')
    post :timeout, params: { match_id: match.id }
    expect(match.reload.status).to eq('finished')
  end
  end
end


