require 'rails_helper'

RSpec.describe "Challenges", type: :request do
  describe "GET /edit" do
    it "returns http success" do
      get "/challenges/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
