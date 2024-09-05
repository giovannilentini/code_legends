class WelcomeController < ApplicationController
  def home
    @user = current_user
    if @user
      redirect_to play_now_path
    end
  end
end
