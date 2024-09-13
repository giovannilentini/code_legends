require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do
  let(:user) { User.create(email: 'user@example.com', password: 'password') }
  let(:friend) { User.create(email: 'friend@example.com', password: 'password') }

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
        expect(flash[:notice]).to eq('Amico aggiunto con successo!')
      end

      it 'does not add a friend if already friends' do
        user.friends << friend

        expect {
          post :create, params: { id: friend.id }
        }.not_to change { user.friends.count }

        expect(response).to redirect_to(user_path(friend))
        expect(flash[:alert]).to eq('Sei già amico di questo utente.')
      end
    end

    context 'when trying to add self as a friend' do
      it 'redirects to root with an alert' do
        expect {
          post :create, params: { id: user.id }
        }.not_to change { user.friends.count }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Non puoi aggiungere te stesso come amico.')
      end
    end
  end
end
