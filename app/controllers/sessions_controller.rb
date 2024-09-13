class SessionsController < ApplicationController

  def login

  end

  def login_post
    user = User.find_by(email: params[:email])
    # If the user has logged with oauth encourage to log with it
    if user&.has_auth0?
      flash[:alert] = "Already logged in with #{user.provider} oauth!"
      redirect_to root_path
    else
      # If the user hasn't confirmed their email
      if user.email_confirmed_at==nil
        flash[:alert]= "Confirm email"
        redirect_to root_path
      else
        if user && user.authenticate(params[:password]) && user.email_confirmed_at
          session[:user_id] = user.id
        else
          flash[:alert] = "Invalid email or password"
          redirect_to login_path
        end
      end
    end
  end

  def signup
    @user = User.new
  end
end