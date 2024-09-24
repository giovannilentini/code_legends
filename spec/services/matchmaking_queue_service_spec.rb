require 'rails_helper'

RSpec.describe MatchmakingQueueService, type: :service do
  let(:user1) { RegisteredUser.create!(id: 1, username: 'User One', password: "password1", email: "test1@test.com") }  # Directly creating a User instance
  let(:user2) { RegisteredUser.create!(id: 2, username: 'User Two', password: "password2", email: "test2@test.com") }
  let(:challenge) {Challenge.create!(id: 1, title: "challenge", difficulty: "easy", description: "challengeee", language: "python3")}
  let(:language) { 'python3' }

  before do
    Challenge.create!(id: 1, title: "challenge", difficulty: "easy", description: "challengeee", language: "python3")
    # Clear Redis before each test
    $redis.flushdb
  end

  describe '.add_to_queue' do
    it 'adds a user to the queue' do
      MatchmakingQueueService.add_to_queue(user1, language)

      expect($redis.zcard(MatchmakingQueueService::REDIS_QUEUE_KEY)).to eq(1)
      expect($redis.hexists(MatchmakingQueueService::REDIS_PLAYER_HASH, "#{user1.id}:#{language}")).to be_truthy
    end

    it 'does not add the same user twice' do
      MatchmakingQueueService.add_to_queue(user1, language)
      MatchmakingQueueService.add_to_queue(user1, language)

      expect($redis.zcard(MatchmakingQueueService::REDIS_QUEUE_KEY)).to eq(1)
    end
  end

  describe '.remove_player' do
    it 'removes a player from the queue' do
      MatchmakingQueueService.add_to_queue(user1, language)
      MatchmakingQueueService.remove_player(user1, language)
      expect($redis.zcard(MatchmakingQueueService::REDIS_QUEUE_KEY)).to eq(0)
      expect($redis.hexists(MatchmakingQueueService::REDIS_PLAYER_HASH, "#{user1.id}:#{language}")).to be_falsey
    end

    it 'does nothing if the player is not in the queue' do
      MatchmakingQueueService.remove_player(user1, language)

      expect($redis.zcard(MatchmakingQueueService::REDIS_QUEUE_KEY)).to eq(0)
    end
  end

  describe '.find_opponent' do
    it 'creates a match if there are two players in the queue' do
      MatchmakingQueueService.add_to_queue(user1, language)
      MatchmakingQueueService.add_to_queue(user2, language)

      expect(Match.count).to eq(1)
    end

    it 'does not create a match if there is only one player' do
      MatchmakingQueueService.add_to_queue(user1, language)

      expect { MatchmakingQueueService.send(:find_opponent) }.not_to change { Match.count }
    end
  end

  describe 'concurrent registered_users joining the queue' do
    it 'handles simultaneous joins and creates matches as expected' do
      number_of_players = 100  # Change this to your desired number of players
      users = []

      # Create registered_users for the test
      number_of_players.times do |i|
        users << RegisteredUser.create!(id: i + 1, username: "User #{i + 1}", password: "password#{i + 1}", email: "test#{i + 1}@test.com")
      end

      threads = []

      # Simulate concurrent registered_users joining the queue
      users.each do |user|
        threads << Thread.new do
          MatchmakingQueueService.add_to_queue(user, language)
        end
      end

      threads.each(&:join)

      # After all registered_users have joined, attempt to find opponents and create matches
      MatchmakingQueueService.send(:find_opponent)

      # Check the number of matches created
      expected_matches = number_of_players / 2  # Assuming pairs are matched
      expect(Match.count).to eq(expected_matches)

      # Check that the queue is empty after matching
      expect($redis.zcard(MatchmakingQueueService::REDIS_QUEUE_KEY)).to eq(0)
    end
  end
end
