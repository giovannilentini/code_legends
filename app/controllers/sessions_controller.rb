class SessionsController < ApplicationController

  def login

  end

  def login_post

    user = User.find_by(email: params[:email])
    if user.has_auth0?
      flash[:alert] = "Login with #{user.provider} oauth"
      redirect_to root_path
    else
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:success]= "Logged in successfully!"
        redirect_to root_path
      else
        flash[:alert] = "Invalid email or password"
        redirect_to login_path
      end
    end
  end

  def signup
    @user = User.new
  end
end