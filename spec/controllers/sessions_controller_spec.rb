require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  let(:user) { RegisteredUser.create!(email: 'user@example.com', username: "testuser", password: 'password', email_confirmed_at: Time.now) }

  describe 'GET /login' do
    it 'renders the login page if not logged in' do
      get login_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('LOGIN') # Replace with actual text you expect on the login page
      expect(response.body).to include('E-mail')  # Check for presence of form fields or labels
      expect(response.body).to include('Password') # Check for presence of form fields or labels
    end

    it 'redirects to root if already logged in' do
      # Simulate user being logged in
      allow_any_instance_of(SessionsController).to receive(:current_user).and_return(user)

      get login_path
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include('You are already logged in.')
    end
  end

  describe 'POST /login_post' do
    context 'with valid credentials' do
      it 'logs in the user and redirects to root' do
        post login_post_path, params: { email: user.email, password: 'password' }

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include('Logged in successfully!')
        expect(session[:user_id]).to eq(user.id)
        expect(cookies[:user_info]).to eq(user.id.to_s)
      end
    end

    context 'with invalid credentials' do
      it 'does not log in and redirects back to login with an error' do
        post login_post_path, params: { email: user.email, password: 'wrongpassword' }
        expect(response).to redirect_to(login_path)
        follow_redirect!
        expect(response.body).to include('Invalid email or password')
        expect(session[:user_id]).to be_nil
      end
    end

    context 'when the user is already logged in with oauth' do
      before do
        user.update(auth0_id: 'auth0|someid', provider: 'auth0')
      end

      it 'redirects to root with an alert' do
        post login_post_path, params: { email: user.email, password: 'password' }

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("Already logged in with #{user.provider} oauth!")
      end
    end
  end

  describe 'GET /signup' do
    it 'renders the signup page' do
      get signup_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Sign Up') # Replace with actual text you expect on the signup page
      expect(response.body).to include('Username')  # Check for presence of form fields or labels
      expect(response.body).to include('E-mail') # Check for presence of form fields or labels
      expect(response.body).to include('Password') # Check for presence of form fields or labels
    end
  end
end
