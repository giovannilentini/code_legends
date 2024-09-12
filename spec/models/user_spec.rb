require 'rails_helper'

RSpec.describe User, type: :model do
  context "when not a guest" do
    let(:user) { User.new(email: email, auth0_id: auth0_id, guest: false, rank: 100) }
    let(:email) { 'example@gmail.com' }
    let(:auth0_id) { '123456' }

    it "is valid with unique email and auth0_id" do
      user.save!
      expect(user).to be_valid
    end

    it "is invalid without an email" do
      user.email = nil
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "is invalid with a duplicate email" do
      User.create!(email: email, auth0_id: '654321', guest: false)
      user.email = email
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it "is invalid without an auth0_id" do
      user.auth0_id = nil
      expect(user).to_not be_valid
      expect(user.errors[:auth0_id]).to include("can't be blank")
    end

    it "is invalid with a duplicate auth0_id" do
      User.create!(email: 'example2@gmail.com', auth0_id: auth0_id, guest: false)
      user.auth0_id = auth0_id
      expect(user).to_not be_valid
      expect(user.errors[:auth0_id]).to include("has already been taken")
    end

  it "has many challenge_proposals" do
    association = User.reflect_on_association(:challenge_proposals)
    expect(association.macro).to eq(:has_many)
  end

  it "has one attached profile_image" do
    expect(user).to respond_to(:profile_image)
  end

  it "has many sent_friend_requests" do
    association = User.reflect_on_association(:sent_friend_requests)
    expect(association.macro).to eq(:has_many)
  end

  it "has many received_friend_requests" do
    association = User.reflect_on_association(:received_friend_requests)
    expect(association.macro).to eq(:has_many)
  end

  it "has many friendships" do
    association = User.reflect_on_association(:friendships)
    expect(association.macro).to eq(:has_many)
  end

  it "has many friends through friendships" do
    association = User.reflect_on_association(:friends)
    expect(association.macro).to eq(:has_many)
    expect(association.options[:through]).to eq(:friendships)
  end

  it "has many inverse_friendships" do
    association = User.reflect_on_association(:inverse_friendships)
    expect(association.macro).to eq(:has_many)
  end

  it "has many inverse_friends through inverse_friendships" do
    association = User.reflect_on_association(:inverse_friends)
    expect(association.macro).to eq(:has_many)
    expect(association.options[:through]).to eq(:inverse_friendships)
    expect(association.options[:source]).to eq(:user)
  end

  it "has many sent_challenge_requests" do
    association = User.reflect_on_association(:sent_challenge_requests)
    expect(association.macro).to eq(:has_many)
  end

  it "has many received_challenge_requests" do
    association = User.reflect_on_association(:received_challenge_requests)
    expect(association.macro).to eq(:has_many)
  end

  it "decreases rank but not below 0" do
    user.decrement_rank(50)
    expect(user.rank).to eq(50)
    user.decrement_rank(100)
    expect(user.rank).to eq(0)
  end

  it "increases rank" do
    user.increment_rank(20)
    expect(user.rank).to eq(120)
  end
end


  context "when a guest" do
    let(:guest_user) { User.new(email: nil, auth0_id: nil, guest: true) }

    it "is valid without an email" do
      expect(guest_user).to be_valid
    end

    it "is valid without an auth0_id" do
      expect(guest_user).to be_valid
    end
  end


  
end