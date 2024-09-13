require 'rails_helper'

RSpec.describe "Settings", type: :request do
  let(:user) { User.create!(email: 'example@gmail.com', username: 'test_user', auth0_id: 'auth0|12345', password:'Password1')}

  before do
    # Simula l'autenticazione
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:user_signed_in?).and_return(true)
  end

  describe "PATCH /users/:id" do
    it "returns http success" do
      patch "/users/#{user.id}", params: { user: { email: "updated@example.com" } }
      

      
      expect(response).to have_http_status(:success).or have_http_status(:redirect)
    end
  end
end
