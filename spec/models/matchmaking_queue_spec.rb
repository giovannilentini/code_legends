# spec/models/matchmaking_queue_spec.rb
require 'rails_helper'
require 'parallel'

RSpec.describe MatchmakingQueue, type: :model do
  let(:language) { 'Ruby' }   # The language for the matchmaking queue
  let(:num_users) { 2000 }      # Number of concurrent users

  before do
    # Ensure the database is clean
    MatchmakingQueue.delete_all
    User.delete_all

    # Create users directly in the test
    @users = []
    num_users.times do |i|
      @users << User.create!(
        username: "User#{i + 1}",
        email: "user#{i + 1}@example.com",
        auth0_id: "auth0|#{i + 1}",  # Assuming auth0_id is unique
        guest: false,
        rank: 0
      )
    end
  end

  it "allows multiple users to join the matchmaking queue concurrently" do
    Parallel.each(@users, in_threads: num_users) do |user|
      # Simulate each user joining the queue with a specific language
      MatchmakingQueue.create!(user: user, status: 'waiting', language: language)
    end

    # Assertions to verify that all users are in the queue
    @users.each do |user|
      expect(MatchmakingQueue.exists?(user_id: user.id, status: 'waiting', language: language)).to be true
    end
  end
end
