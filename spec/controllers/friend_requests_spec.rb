require 'rails_helper'

RSpec.describe FriendRequestsController, type: :controller do
  before do
    @user = RegisteredUser.create(email: "user@example.com", password: "password")
    @friend = RegisteredUser.create(email: "friend@example.com", password: "password")
    session[:user_id] = @user.id
  end

  describe 'POST #create' do
    context 'quando esiste già una richiesta di amicizia' do
      before do
        FriendRequest.create(user_id: @user.id, friend_id: @friend.id)
      end

      it 'reindirizza e mostra un alert' do
        post :create, params: { user_id: @friend.id }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'quando gli utenti sono già amici' do
      before do
        Friendship.create(user_id: @user.id, friend_id: @friend.id)
      end

      it 'reindirizza e mostra un alert' do
        post :create, params: { user_id: @friend.id }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'quando la richiesta di amicizia è valida' do
      it 'crea una nuova richiesta di amicizia e reindirizza con successo' do
        expect {
          post :create, params: { user_id: @friend.id }
        }.to change(FriendRequest, :count).by(1)

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

      expect(response).to redirect_to(root_path)
    end
  end
end
