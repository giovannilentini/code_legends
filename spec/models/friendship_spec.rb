require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let(:user1) { User.create!(auth0_id: 'user1', email: 'example1@gmail.com', password: '123456') }
  let(:user2) { User.create!(auth0_id: 'user2', email: 'example2@gmail.com', password: '123456') }

  it "belongs to user" do
    association = Friendship.reflect_on_association(:user)
    expect(association.macro).to eq(:belongs_to)
  end
  it "belongs to friend" do
    association = Friendship.reflect_on_association(:friend)
    expect(association.macro).to eq(:belongs_to)
  end

  it "is invalid without user_id" do
    friendship = Friendship.new(user_id: nil, friend_id: user2.id)
    expect(friendship).to_not be_valid
    expect(friendship.errors[:user_id]).to include("can't be blank")
  end
    
  it "is invalid without friend_id" do
    friendship = Friendship.new(user_id: user1.id, friend_id: nil)
    expect(friendship).to_not be_valid
    expect(friendship.errors[:friend_id]).to include("can't be blank")
  end

  it "is invalid if user_id and friend_id are the same" do
    friendship = Friendship.new(user_id: user1.id, friend_id: user1.id)
    expect(friendship).to_not be_valid
    expect(friendship.errors[:friend_id]).to include("cannot be the same as user")    
  end

  it "is invalid if user_id and friend_id are not unique" do
    Friendship.create!(user_id: user1.id, friend_id: user2.id)
    friendship2 = Friendship.new(user_id: user1.id, friend_id: user2.id)
    expect(friendship2).to_not be_valid
    expect(friendship2.errors[:user_id]).to include("has already been taken")
  end
end

