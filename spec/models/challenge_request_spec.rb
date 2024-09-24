require 'rails_helper'

RSpec.describe ChallengeRequest, type: :model do
  describe 'associations' do
    it 'belongs to a sender (User)' do
      association = described_class.reflect_on_association(:sender)
      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq('User')
      expect(association.foreign_key).to eq('user_id')
    end

    it 'belongs to a receiver (User)' do
      association = described_class.reflect_on_association(:receiver)
      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq('User')
      expect(association.foreign_key).to eq('friend_id')
    end
  end

  describe 'validations' do
    let(:user1) { RegisteredUser.create(email: 'user1@example.com',  password: 'password') }
    let(:user2) { RegisteredUser.create(email: 'user2@example.com',  password: 'password') }
    it 'is valid with a user_id, friend_id, and language' do
      challenge_request = ChallengeRequest.new(user_id: user1.id, friend_id: user2.id, language: 'Ruby')
      expect(challenge_request).to be_valid
    end

    it 'is invalid without a user_id' do
      challenge_request = ChallengeRequest.new(friend_id: 2, language: 'Ruby')
      expect(challenge_request).not_to be_valid
      expect(challenge_request.errors[:user_id]).to include("can't be blank")
    end

    it 'is invalid without a friend_id' do
      challenge_request = ChallengeRequest.new(user_id: 1, language: 'Ruby')
      expect(challenge_request).not_to be_valid
      expect(challenge_request.errors[:friend_id]).to include("can't be blank")
    end

    it 'is invalid without a language' do
      challenge_request = ChallengeRequest.new(user_id: 1, friend_id: 2)
      expect(challenge_request).not_to be_valid
      expect(challenge_request.errors[:language]).to include("can't be blank")
    end
  end
end
