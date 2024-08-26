require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  describe "GET #admin_profile" do
    it "renders the admin_profile template" do
      get :admin_profile
      expect(response).to render_template(:admin_profile)
    end

    it "assigns only challenges with status -1" do
      challenge_1 = Challenge.create(description: "Challenge 1", status: -1)
      challenge_2 = Challenge.create(description: "Challenge 2", status: 1)

      get :admin_profile

      expect(assigns(:challenges)).to include(challenge_1)
      expect(assigns(:challenges)).not_to include(challenge_2)
    end
  end

  describe "POST #update_status" do
    it "accepts a challenge and sets status to 1" do
      challenge = Challenge.create(description: "Accept me", status: -1)
      post :update_status, params: { id: challenge.id, status: 1 }
      challenge.reload
      expect(challenge.status).to eq(1)
    end

    it "rejects a challenge and stores rejection reason" do
      challenge = Challenge.create(description: "Reject me", status: -1)
      post :update_status, params: { id: challenge.id, status: 0, rejection_reason: "Not suitable" }
      challenge.reload
      expect(challenge.status).to eq(0)
      expect(challenge.rejection_reason).to eq("Not suitable")
    end
  end
end
