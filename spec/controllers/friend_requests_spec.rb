require 'rails_helper'

RSpec.describe FriendRequestsController, type: :controller do
  before do
    @user = User.create(email: "user@example.com", password: "password")
    @friend = User.create(email: "friend@example.com", password: "password")
    session[:user_id] = @user.id
  end

  describe 'POST #create' do
    context 'quando esiste già una richiesta di amicizia' do
      before do
        FriendRequest.create(user_id: @user.id, friend_id: @friend.id)
      end

      it 'reindirizza e mostra un alert' do
        post :create, params: { user_id: @friend.id }
        expect(flash[:alert]).to eq("È già presente una richiesta di amicizia in sospeso per questo utente.")
        expect(response).to redirect_to(root_path)
      end
    end

    context 'quando gli utenti sono già amici' do
      before do
        Friendship.create(user_id: @user.id, friend_id: @friend.id)
      end

      it 'reindirizza e mostra un alert' do
        post :create, params: { user_id: @friend.id }
        expect(flash[:alert]).to eq("Siete già amici.")
        expect(response).to redirect_to(root_path)
      end
    end

    context 'quando la richiesta di amicizia è valida' do
      it 'crea una nuova richiesta di amicizia e reindirizza con successo' do
        expect {
          post :create, params: { user_id: @friend.id }
        }.to change(FriendRequest, :count).by(1)

        expect(flash[:notice]).to eq("Richiesta di amicizia inviata con successo.")
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST #accept' do
    before do
      @friend_request = FriendRequest.create(user_id: @user.id, friend_id: @friend.id)
    end

    it 'accetta la richiesta di amicizia e crea la relazione di amicizia' do
      expect {
        post :accept, params: { id: @friend_request.id }
      }.to change(Friendship, :count).by(2)

      expect(flash[:notice]).to eq('Richiesta di amicizia accettata.')
      expect(response).to redirect_to(root_path)
      expect(FriendRequest.exists?(@friend_request.id)).to be_falsey
    end
  end

  describe 'POST #reject' do
    before do
      @friend_request = FriendRequest.create(user_id: @user.id, friend_id: @friend.id)
    end

    it 'rifiuta la richiesta di amicizia e la elimina' do
      expect {
        post :reject, params: { id: @friend_request.id }
      }.to change(FriendRequest, :count).by(-1)

      expect(flash[:notice]).to eq('Richiesta di amicizia rifiutata.')
      expect(response).to redirect_to(root_path)
    end
  end
end
