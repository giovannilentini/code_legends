require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { User.create!(email: 'user@example.com', username: 'username', password: 'password') }
  let(:another_user) { User.create!(email: 'another@example.com', username: 'another_username', password: 'password') }

  describe 'GET #show' do
    before { get :show, params: { id: user.id } }

    it 'assigns the requested user to @user_profile' do
      expect(assigns(:user_profile)).to eq(user)
    end

    it 'assigns accepted challenges to @accepted_challenges' do
      expect(assigns(:accepted_challenges)).to eq([])
    end

    it 'assigns rejected challenges to @rejected_challenges' do
      expect(assigns(:rejected_challenges)).to eq([])
    end

    it 'assigns pending challenges if user is current_user' do
      allow(controller).to receive(:current_user).and_return(user)
      get :show, params: { id: user.id }
      expect(assigns(:pending_challenges)).to eq([])
    end

    it 'does not assign pending challenges if user is not current_user' do
      allow(controller).to receive(:current_user).and_return(another_user)
      get :show, params: { id: user.id }
      expect(assigns(:pending_challenges)).to be_nil
    end
  end

  describe 'POST #create' do
    before do
      User.destroy_all
    end
    context 'when user does not exist' do
      it 'creates a new user and redirects to root path' do
        post :create, params: { user: { email: 'newuser@example.com', username: 'newuser', password: 'password' } }
        expect(User.count).to eq(1) 
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Please check your email to confirm your account.')
      end
    end

    context 'when user already exists' do
      it 'does not create a new user and redirects to root path with alert' do
        post :create, params: { user: { email: 'user2@example.com', username: 'newusername', password: 'password' } }
        expect(User.count).to eq(1) 
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user already exists with auth0' do
      before { user.update(auth0_id: "google-auth0|test", provider: "auth0") }

      it 'redirects to root path with an appropriate alert' do
        post :create, params: { user: { email: 'user@example.com', username: 'newusername', password: 'password' } }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("User with mail user@example.com already registered with auth0 oauth")
      end
    end
  end

end
