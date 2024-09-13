require 'rails_helper'

RSpec.describe MatchmakingQueue, type: :model do
  let(:user) { User.create!(auth0_id: 'user1', email: 'example1@gmail.com', password: 'password') }

  it "belongs to user" do
    association = MatchmakingQueue.reflect_on_association(:user)
    expect(association.macro).to eq(:belongs_to)
  end

  it "is invalid without user" do
    matchmaking_queue = MatchmakingQueue.new(user: nil, language:'python3', status:-1)
    expect(matchmaking_queue).to_not be_valid
    expect(matchmaking_queue.errors[:user]).to include("can't be blank")
  end

  it "is invalid without language" do
    matchmaking_queue = MatchmakingQueue.new(user: user, language:nil, status: -1)
    expect(matchmaking_queue).to_not be_valid
    expect(matchmaking_queue.errors[:language]).to include("can't be blank")
  end

  it "is invalid without status" do
    matchmaking_queue = MatchmakingQueue.new(user: user, language:'python3', status: nil)
    expect(matchmaking_queue).to_not be_valid
    expect(matchmaking_queue.errors[:status]).to include("can't be blank")
  end
end
