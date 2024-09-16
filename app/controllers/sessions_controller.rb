class SessionsController < ApplicationController

  def login


    if @current_user
      flash[:notice] = "You are already logged in."
    redirect_to root_path
    end
  end

  def login_post
    user = User.find_by(email: params[:email])
    if user
      if user.has_auth0?
        flash[:alert] = "Already logged in with #{user.provider} oauth!"
        redirect_to root_path
      else
        if user.authenticate(params[:password])
          session[:user_id] = user.id
          cookies[:user_info] = { value: user.id, expires: 1.year.from_now }
          flash[:success]= "Logged in successfully!"
          redirect_to root_path
        else
          flash[:alert] = "Invalid email or password"
          redirect_to login_path
        end
      end
    else
      flash[:alert] = "User does not exist"
      redirect_to root_path
    end
  end

  def signup
    @user = User.new
  end
end