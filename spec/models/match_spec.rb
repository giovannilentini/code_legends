require 'rails_helper'

RSpec.describe Match, type: :model do
  describe 'associations' do
    it 'belongs to player_1' do
      association = Match.reflect_on_association(:player_1)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:class_name]).to eq('User')
      expect(association.options[:foreign_key]).to eq('player_1_id')
    end

    it 'belongs to player_2' do
      association = Match.reflect_on_association(:player_2)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:class_name]).to eq('User')
      expect(association.options[:foreign_key]).to eq('player_2_id')
    end

    it 'belongs to challenge' do
      association = Match.reflect_on_association(:challenge)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has many chat_messages' do
      association = Match.reflect_on_association(:chat_messages)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  describe 'validations' do
    let(:user1) { RegisteredUser.create(email: 'user1@example.com', password: 'password') }
    let(:user2) { RegisteredUser.create(email: 'user2@example.com', password: 'password') }
    let(:challenge_proposal) { ChallengeProposal.create(title: 'Challenge Proposal', description: 'Proposal description', test_cases:"asdasd", user: user1) }
    let(:challenge) { Challenge.create(title: 'Challenge',difficulty: "easy", language: "python3", description: 'Challenge description', challenge_proposal: challenge_proposal) }

    it 'is valid with different players and a challenge' do
      match = Match.new(player_1: user1, player_2: user2, challenge: challenge)
      expect(match).to be_valid
    end

    it 'is invalid with the same players' do
      match = Match.new(player_1: user1, player_2: user1, challenge: challenge)
      match.validate
      expect(match.errors[:player_2]).to include('must be different from Player 1')
    end

    it 'is invalid without player_1' do
      match = Match.new(player_2: user2, challenge: challenge)
      match.validate
      expect(match.errors[:player_1]).to include("can't be blank")
    end

    it 'is invalid without player_2' do
      match = Match.new(player_1: user1, challenge: challenge)
      match.validate
      expect(match.errors[:player_2]).to include("can't be blank")
    end

    it 'is invalid without a challenge' do
      match = Match.new(player_1: user1, player_2: user2)
      match.validate
      expect(match.errors[:challenge]).to include("can't be blank")
    end
  end
end