require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/sessions/show"
      expect(response).to have_http_status(:success)
    end
  end

end
