require 'rails_helper'

RSpec.describe "Challenges", type: :request do
  before do
    @challenge = Challenge.create!(description: "Test Challenge", status: "pending")
  end

  describe "GET /challenges/:id" do
    it "returns http success" do
      get "/challenges/#{@challenge.id}"
      expect(response).to have_http_status(:success)
    end
  end
end
