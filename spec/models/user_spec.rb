require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#guest?' do
    it 'returns true if the user is a guest' do
      user = Guest.create
      expect(user.guest?).to be true
    end

    it 'returns false if the user is not a guest' do
      user = RegisteredUser.new
      expect(user.guest?).to be false
    end
  end
  describe '#admin?' do
    it 'returns true if the user is an admin' do
      user = RegisteredUser.new(is_admin: true)
      expect(user.admin?).to be true
    end

    it 'returns false if the user is not an admin' do
      user = RegisteredUser.new(is_admin: false)
      expect(user.admin?).to be false
    end
  end
  describe '#has_password?' do
    it 'returns true if the user has a password digest' do
      user = RegisteredUser.new(password: 'somepassworddigest')
      expect(user.has_password?).to be true
    end

    it 'returns false if the user does not have a password digest' do
      user = RegisteredUser.new(password: nil)
      expect(user.has_password?).to be false
    end
  end

  describe 'email validation' do
    it 'is valid with a unique email when not a guest' do
      user = RegisteredUser.new(email: 'test@example.com', password: "password_digest")
      expect(user).to be_valid
    end

    it 'is invalid without an email when not a guest' do
      user = RegisteredUser.new(email: nil)
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'does not validate email for guest registered_users' do
      guest_user = Guest.new(email: nil)
      expect(guest_user).to be_valid
    end
  end
  describe 'associations' do
    let(:user_1) { RegisteredUser.create!(email: 'test@example.com', password: "password_digest")}
    let(:user_2) { RegisteredUser.create!(email: 'test2@example.com', password: "password_digest")}
    let(:user_3) { RegisteredUser.create!(email: 'test3@example.com', password: "password_digest")}
    it 'can have many sent friend requests' do
      friend_request1 = FriendRequest.create!(user_id: user_1.id, friend_id: user_2.id)
      friend_request2 = FriendRequest.create!(user_id: user_1.id, friend_id: user_3.id)
      expect(user_1.sent_friend_requests.count).to eq(2)
    end

    it 'can have many received friend requests' do
      friend_request1 = FriendRequest.create(user_id: user_2.id, friend_id: user_1.id)
      friend_request2 = FriendRequest.create(user_id: user_3.id, friend_id: user_1.id)

      expect(user_1.received_friend_requests.count).to eq(2)
    end
  end
end

