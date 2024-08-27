require 'rails_helper'

RSpec.describe "PlayNows", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/play_now/index"
      expect(response).to have_http_status(:success)
    end
  end

end
