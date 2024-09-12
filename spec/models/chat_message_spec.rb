require 'rails_helper'

RSpec.describe ChatMessage, type: :model do
  it "belongs to user" do
    association = ChatMessage.reflect_on_association(:user)
    expect(association.macro).to eq(:belongs_to)
  end
  it "belongs to match" do
    association = ChatMessage.reflect_on_association(:match)
    expect(association.macro).to eq(:belongs_to)
  end
end
