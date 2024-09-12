require 'rails_helper'

RSpec.describe ChallengeRequest, type: :model do
  it "belongs to sender" do
    association = ChallengeRequest.reflect_on_association(:sender)
    expect(association.macro).to eq(:belongs_to)
  end

  it "belongs to receiver" do
    association = ChallengeRequest.reflect_on_association(:receiver)
    expect(association.macro).to eq(:belongs_to)
  end

  it "is invalid without user_id" do
    challenge_request = ChallengeRequest.new(user_id: nil, friend_id:654321, language: "python3")
    expect(challenge_request).to_not be_valid
    expect(challenge_request.errors[:user_id]).to include("can't be blank")
  end
    
  it "is invalid without friend_id" do
    challenge_request = ChallengeRequest.new(user_id: 123456, friend_id: nil, language: "python3")
    expect(challenge_request).to_not be_valid
    expect(challenge_request.errors[:friend_id]).to include("can't be blank")
  end

  it "is invalid without language" do
    challenge_request = ChallengeRequest.new(user_id: 123456, friend_id: 654321, language: nil)
    expect(challenge_request).to_not be_valid
    expect(challenge_request.errors[:language]).to include("can't be blank")
  end

end
