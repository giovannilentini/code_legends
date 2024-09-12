require 'rails_helper'

RSpec.describe Match, type: :model do
  let(:player1) { User.create!(auth0_id: 'user1', email: 'example1@gmail.com ')}
  let(:player2) { User.create!(auth0_id: 'user2', email: 'example2@gmail.com') }

  it "belongs to player_1" do
    association = Match.reflect_on_association(:player_1)
    expect(association.macro).to eq(:belongs_to)
  end
  it "belongs to player_2" do
    association = Match.reflect_on_association(:player_2)
    expect(association.macro).to eq(:belongs_to)
  end

  it "is invalid without player_1" do
    match = Match.new(player_1: nil, player_2: player2)
    expect(match).to_not be_valid
    expect(match.errors[:player_1]).to include("can't be blank")
  end
    
  it "is invalid without player_2" do
    match = Match.new(player_1: player1, player_2: nil)
    expect(match).to_not be_valid
    expect(match.errors[:player_2]).to include("can't be blank")
  end

  it "is invalid if player_1 and player_2 are the same" do
    match = Match.new(player_1: player1, player_2: player1)
    expect(match).to_not be_valid
    expect(match.errors[:player_2]).to include("must be different from Player 1")
  end

  it "has many chat_messages" do
    association = Match.reflect_on_association(:chat_messages)
    expect(association.macro).to eq(:has_many)
  end

  it "destroys associated chat_messages when deleted" do
    match = Match.create!(player_1: player1, player_2: player2)
    chat_message = ChatMessage.create!(user: player1, match: match, content: 'Hello')

    expect { match.destroy }.to change { ChatMessage.count }.by(-1)
  end
end
