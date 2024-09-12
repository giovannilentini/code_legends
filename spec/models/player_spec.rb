require 'rails_helper'

RSpec.describe Player, type: :model do
  let(:player1) { User.create!(auth0_id: 'user1', email: 'example1@gmail.com ')}
  let(:player2) { User.create!(auth0_id: 'user2', email: 'example2@gmail.com') }

  it "has many challenges_as_player1" do
    association = Player.reflect_on_association(:challenges_as_player1)
    expect(association.macro).to eq(:has_many)
  end

  it "has many challenges_as_player2" do
    association = Player.reflect_on_association(:challenges_as_player2)
    expect(association.macro).to eq(:has_many)
  end

  #it "has a default value of false for waiting" do
  # player = Player.new
  #  expect(player.waiting).to be false
  #end
end
