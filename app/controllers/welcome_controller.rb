class WelcomeController < ApplicationController
  def home
    if current_user
      @user = User.find(session[:user_id])
    end
  end
end
