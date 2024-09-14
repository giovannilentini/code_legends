require 'rails_helper'

RSpec.describe MatchmakingQueueController, type: :controller do
  let(:user) { User.create!(email: 'user@example.com', password: 'password', username: 'User1', guest: false) }
  let(:user2) { User.create!(email: 'user2@example.com', password: 'password', username: 'User2', guest: false) }
  let(:challenge_proposal) { ChallengeProposal.create!(user: user, title: 'Test Challenge', test_cases: 'test cases', description: 'A challenging challenge') }
  let(:challenge) { Challenge.create!(title: 'Test Challenge', description: 'A challenging challenge', challenge_proposal: challenge_proposal) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow_any_instance_of(MatchmakingQueueService).to receive(:add_to_queue).and_return(true)
  end

  describe 'GET #play_now' do
    it 'assigns @last_matches and @match_details' do
      match = Match.create!(player_1_id: user.id, player_2_id: user2.id, challenge: challenge, status: 'finished', winner_id: user.id)
      get :play_now
      expect(assigns(:last_matches)).to include(match)
      expect(assigns(:match_details)).to include(
                                           {
                                             opponent: user2.username,
                                             result: 'Win',
                                             date: match.updated_at.strftime("%B %d, %Y")
                                           }
                                         )
    end
  end

  describe 'POST #cancel' do
    it 'removes user from matchmaking queue and redirects to play_now_path' do
      allow(MatchmakingQueueService).to receive(:remove_from_queue).with(user).and_call_original

      post :cancel
      expect(response).to redirect_to(play_now_path)
    end
  end
end
