require 'rails_helper'

RSpec.describe Auth0Controller, type: :controller do
  describe "POST #callback" do
    let(:auth_info) do
      {
        'uid' => 'auth0|12345',
        'info' => {
          'email' => 'test@example.com',
          'name' => 'Test User',
          'password' => 'Password1!'
        }
      }
    end

    before do
      # Simuliamo l'ambiente di OmniAuth
      request.env['omniauth.auth'] = auth_info
      allow(Auth0Service).to receive(:get_user_info).with('auth0|12345').and_return({ "username" => "test_user" })
    end

    context "when user exists" do
      it "finds the user and logs them in" do
        user = User.create!(email: 'test@example.com', username: 'test_user', auth0_id: 'auth0|12345', password:'Password1')

        post :callback

        expect(session[:user_id]).to eq(user.id)
        expect(session[:userinfo]['auth0_id']).to eq(user.auth0_id)
        expect(flash[:success]).to be_nil
        expect(response).to redirect_to(root_path)
        expect(user.reload.username).to eq('test_user') # Il nome utente viene aggiornato
      end
    end

    context "when user does not exist" do
      it "creates a new user and logs them in" do
        expect {
          post :callback
        }.to change(User, :count).by(1)

        user = User.last
        expect(user.email).to eq('test@example.com')
        expect(user.username).to eq('test_user')
        expect(user.auth0_id).to eq('auth0|12345')

        expect(session[:user_id]).to eq(user.id)
        expect(session[:userinfo]['auth0_id']).to eq(user.auth0_id)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET #failure" do
    it "displays an error message and redirects to root path" do
      get :failure, params: { error: 'invalid_credentials', error_description: 'Invalid credentials provided' }

      expect(flash[:alert]).to eq("Authentication failed: Invalid credentials provided Please try again.")
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET #logout" do
    context "when current user is a guest" do
      it "destroys the guest user and logs them out" do
        user = User.create!(email: 'guest@example.com', username: 'guest_user', guest: true, password:'Password1!')
        allow(controller).to receive(:current_user).and_return(user)

        get :logout

        expect(User.exists?(user.id)).to be_falsey
        expect(flash[:success]).to eq("You have been logged out.")
        expect(response).to redirect_to(root_url)
      end
    end

    context "when current user has Auth0" do
      it "logs out using Auth0 and resets session" do
        user = User.create!(email: 'auth0user@example.com', username: 'auth0_user', guest: false, auth0_id: 'auth0|12345', password:'Password1!')
        allow(controller).to receive(:current_user).and_return(user)
        allow(controller).to receive(:logout_url).and_return('https://auth0.com/v2/logout')

        get :logout

        expect(session[:user_id]).to be_nil
        expect(flash[:success]).to eq("You have been logged out.")
        expect(response).to redirect_to('https://auth0.com/v2/logout')
      end
    end

    context "when current user does not have Auth0" do
      it "logs out locally and resets session" do
        user = User.create!(email: 'localuser@example.com', username: 'local_user', guest: false, password: 'Password1!')
        allow(controller).to receive(:current_user).and_return(user)

        get :logout

        expect(session[:user_id]).to be_nil
        expect(flash[:success]).to eq("You have been logged out.")
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
