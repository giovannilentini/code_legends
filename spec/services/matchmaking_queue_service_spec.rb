require 'rails_helper'

RSpec.describe MatchmakingQueueService, type: :service do
  let(:user1) { User.create!(email: 'user1@example.com', guest: false, password: 'password') }
  let(:user2) { User.create!(email: 'user2@example.com', guest: false, password: 'password') }
  let(:language) { 'python3' }
  let(:challenge_proposal) { ChallengeProposal.create!(user: user1, title: 'Test Challenge', test_cases: "asuyidgas", description: 'A challenging challenge') }
  let(:challenge) { Challenge.create!(title: 'Test Challenge', difficulty: "easy",  description: 'A challenging challenge', challenge_proposal: challenge_proposal, language: language) }

  before do
    # Stub ActionCable server broadcasting
    allow(ActionCable.server).to receive(:broadcast)
  end

  describe '#add_to_queue' do
    context 'when the user is not already in the queue' do
      it 'adds the user to the queue and finds an opponent' do
        service = MatchmakingQueueService.new(user1)

        expect { service.add_to_queue(language) }.to change { MatchmakingQueue.count }.by(1)
        expect(MatchmakingQueue.exists?(user: user1, language: language, status: 'waiting')).to be_truthy
      end
    end

    context 'when the user is already in the queue with the same language' do
      before do
        MatchmakingQueue.create!(user: user1, status: 'waiting', language: language)
      end

      it 'does not add the user to the queue again' do
        service = MatchmakingQueueService.new(user1)

        expect { service.add_to_queue(language) }.not_to change { MatchmakingQueue.count }
      end
    end

    context 'when the user is playing' do
      before do
        MatchmakingQueue.create!(user: user1, status: 'playing', language: language)
      end

      it 'does not add the user to the queue' do
        service = MatchmakingQueueService.new(user1)

        expect { service.add_to_queue(language) }.not_to change { MatchmakingQueue.count }
      end
    end

    context 'when there is an opponent available' do
      before do
        Challenge.create!(title: 'Test Challenge', description: 'A challenging challenge', difficulty: "easy", challenge_proposal: challenge_proposal, language: language)
        Challenge.delete_all # Ensure no challenges are present

        service = MatchmakingQueueService.new(user1)

        expect { service.add_to_queue(language) }.not_to change { Match.count }
        expect(ActionCable.server).not_to have_received(:broadcast)
      end
    end
  end

  describe 'Remove from queue' do
    it 'removes the user from the queue' do
      MatchmakingQueue.create!(user: user1, status: 'waiting', language: language)

      expect { MatchmakingQueueService.remove_from_queue(user1) }.to change { MatchmakingQueue.count }.by(-1)
    end
  end
end

