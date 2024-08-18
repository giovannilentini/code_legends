require 'rails_helper'

RSpec.describe Challenge, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      challenge = Challenge.new(description: "New Challenge", status: -1)
      expect(challenge).to be_valid
    end

    it "is not valid without a description" do
      challenge = Challenge.new(status: -1)
      expect(challenge).not_to be_valid
    end

    it "has a default status of -1" do
      challenge = Challenge.create(description: "Challenge with default status")
      expect(challenge.status).to eq(-1)
    end

    it "can store a rejection reason" do
      challenge = Challenge.create(description: "Rejected Challenge", status: 0, rejection_reason: "Not challenging enough")
      expect(challenge.rejection_reason).to eq("Not challenging enough")
    end
  end
end
