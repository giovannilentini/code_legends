require 'rails_helper'

RSpec.describe MatchmakingQueueController, type: :controller do
  let(:user) { RegisteredUser.create!(email: 'user@example.com', password: 'password', username: 'User1',) }
  let(:user2) { RegisteredUser.create!(email: 'user2@example.com', password: 'password', username: 'User2') }
  let(:challenge_proposal) { ChallengeProposal.create!(user: user, title: 'Test Challenge', test_cases: 'test cases', description: 'A challenging challenge') }
  let(:challenge) { Challenge.create!(title: 'Test Challenge', language: "python3", difficulty: "easy",  description: 'A challenging challenge', challenge_proposal: challenge_proposal) }
  let(:language){"python3"}
  before do
    allow(controller).to receive(:current_user).and_return(user)
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
      allow(MatchmakingQueueService).to receive(:remove_player).with(user, language).and_call_original

      post :cancel
      expect(response).to redirect_to(play_now_path)
    end
  end
end
