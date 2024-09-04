require 'rails_helper'

RSpec.describe "ChallengeProposals", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/challenge_proposals/new"
      expect(response).to have_http_status(:success)
    end
  end

end
