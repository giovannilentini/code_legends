require 'rails_helper'

RSpec.describe ChatMessage, type: :model do
  describe 'associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to a match' do
      association = described_class.reflect_on_association(:match)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'validations for guests' do
    let(:user1) { RegisteredUser.create(email: 'user1@example.com', password: 'password') }
    it 'allows a non-guest user to send messages' do
      match = Match.new(id: 1)
      chat_message = ChatMessage.new(user: user1, match: match, content: "Hello!")

      expect(chat_message).to be_valid
    end

    it 'does not allow a guest user to send messages' do
      user = Guest.create
      match = Match.new(id: 1)
      chat_message = ChatMessage.new(user: user, match: match, content: "Hello!")

      expect(chat_message).not_to be_valid
    end
  end

  describe 'message content' do
    it 'is valid with non-empty content' do
      user = RegisteredUser.new(id: 1)
      match = Match.new(id: 1)
      chat_message = ChatMessage.new(user: user, match: match, content: "Test message")

      expect(chat_message).to be_valid
    end

    it 'is invalid with empty content' do
      user = RegisteredUser.new(id: 1)
      match = Match.new(id: 1)
      chat_message = ChatMessage.new(user: user, match: match, content: "")

      expect(chat_message).not_to be_valid
      expect(chat_message.errors[:content]).to include("Message must be not empty!")
    end
  end

  describe 'message length' do
    it 'is valid if content length is within limits' do
      user = RegisteredUser.new(id: 1)
      match = Match.new(id: 1)
      chat_message = ChatMessage.new(user: user, match: match, content: "a" * 250)

      expect(chat_message).to be_valid
    end

    it 'is invalid if content length exceeds the limit' do
      user = RegisteredUser.new(id: 1)
      match = Match.new(id: 1)
      chat_message = ChatMessage.new(user: user, match: match, content: "a" * 501)

      expect(chat_message).not_to be_valid
      expect(chat_message.errors[:content]).to include("Message must is too long!(max. 500)")
    end
  end
end
