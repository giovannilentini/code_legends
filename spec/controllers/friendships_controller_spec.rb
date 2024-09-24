require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do
  let(:user) { RegisteredUser.create!(email: 'user@example.com', password: 'password') }
  let(:friend) { RegisteredUser.create!(email: 'friend@example.com', password: 'password') }

  before do
    session[:user_id] = user.id
  end

  describe 'POST #create' do
    context 'when the user exists' do
      it 'adds a friend successfully' do
        expect {
          post :create, params: { id: friend.id }
        }.to change { user.friends.count }.by(1)

        expect(response).to redirect_to(user_path(friend))
      end

      it 'does not add a friend if already friends' do
        user.friends << friend

        expect {
          post :create, params: { id: friend.id }
        }.not_to change { user.friends.count }

        expect(response).to redirect_to(user_path(friend))
      end
    end

    context 'when trying to add self as a friend' do
      it 'redirects to root with an alert' do
        expect {
          post :create, params: { id: user.id }
        }.not_to change { user.friends.count }

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
