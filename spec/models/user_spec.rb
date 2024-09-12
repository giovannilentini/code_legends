require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#guest?' do
    it 'returns true if the user is a guest' do
      user = User.new(guest: true)
      expect(user.guest?).to be true
    end

    it 'returns false if the user is not a guest' do
      user = User.new(guest: false)
      expect(user.guest?).to be false
    end
  end
  describe '#admin?' do
    it 'returns true if the user is an admin' do
      user = User.new(is_admin: true)
      expect(user.admin?).to be true
    end

    it 'returns false if the user is not an admin' do
      user = User.new(is_admin: false)
      expect(user.admin?).to be false
    end
  end
  describe '#has_password?' do
    it 'returns true if the user has a password digest' do
      user = User.new(password_digest: 'somepassworddigest')
      expect(user.has_password?).to be true
    end

    it 'returns false if the user does not have a password digest' do
      user = User.new(password_digest: nil)
      expect(user.has_password?).to be false
    end
  end

  describe 'email validation' do
    it 'is valid with a unique email when not a guest' do
      user = User.new(email: 'test@example.com', guest: false, password_digest: "password_digest")
      expect(user).to be_valid
    end

    it 'is invalid without an email when not a guest' do
      user = User.new(email: nil, guest: false)
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'does not validate email for guest users' do
      guest_user = User.new(guest: true, email: nil, password_digest: "guest")
      expect(guest_user).to be_valid
    end
  end
  describe 'associations' do
    let(:user_1) { User.create!(email: 'test@example.com', guest: false, password_digest: "password_digest")}
    let(:user_2) { User.create!(email: 'test2@example.com', guest: false, password_digest: "password_digest")}
    let(:user_3) { User.create!(email: 'test3@example.com', guest: false, password_digest: "password_digest")}
    it 'can have many sent friend requests' do
      friend_request1 = FriendRequest.create(user_id: user_1.id, friend_id: user_2.id)
      friend_request2 = FriendRequest.create(user_id: user_1.id, friend_id: user_3.id)

      expect(user_1.sent_friend_requests.count).to eq(2)
    end

    it 'can have many received friend requests' do
      friend_request1 = FriendRequest.create(user_id: user_2.id, friend_id: user_1.id)
      friend_request2 = FriendRequest.create(user_id: user_3.id, friend_id: user_1.id)

      expect(user_1.received_friend_requests.count).to eq(2)
    end
  end
end

