require 'rails_helper'

RSpec.describe Challenge, type: :model do
  it "belongs to challenge proposal" do
    association = Challenge.reflect_on_association(:challenge_proposal)
    expect(association.macro).to eq(:belongs_to)
  end
  it "is invalid without title" do
    challenge = Challenge.new(title: nil, description: "Valid Description")
    expect(challenge).to_not be_valid
    expect(challenge.errors[:title]).to include("can't be blank")
  end
  it "is invalid without description" do
    challenge = Challenge.new(title: "Valid Title", description: nil)
    expect(challenge).to_not be_valid
    expect(challenge.errors[:description]).to include("can't be blank")
  end



end
