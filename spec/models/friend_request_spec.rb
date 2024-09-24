require 'rails_helper'

RSpec.describe FriendRequest, type: :model do
  describe 'associations' do
    it 'belongs to sender' do
      association = FriendRequest.reflect_on_association(:sender)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:class_name]).to eq('RegisteredUser')
      expect(association.options[:foreign_key]).to eq('user_id')
    end

    it 'belongs to receiver' do
      association = FriendRequest.reflect_on_association(:receiver)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:class_name]).to eq('RegisteredUser')
      expect(association.options[:foreign_key]).to eq('friend_id')
    end
  end

  describe 'validations' do
    let(:user1) { RegisteredUser.create(email: 'user1@example.com', password: 'password') }
    let(:user2) { RegisteredUser.create(email: 'user2@example.com', password: 'password') }

    it 'is valid with sender and receiver' do
      friend_request = FriendRequest.new(user_id: user1.id, friend_id: user2.id)
      expect(friend_request).to be_valid
    end

    it 'is invalid without a sender' do
      friend_request = FriendRequest.new(friend_id: user2.id)
      friend_request.validate
      expect(friend_request.errors[:user_id]).to include("can't be blank")
    end

    it 'is invalid without a receiver' do
      friend_request = FriendRequest.new(user_id: user1.id)
      friend_request.validate
      expect(friend_request.errors[:friend_id]).to include("can't be blank")
    end
  end
end
