class WelcomeController < ApplicationController
  def index
    if session[:user_id].present?
      @user = current_user
      render 'logged_index'
    else
      render 'index'
    end
  end
  def logged_index
    @user = current_user
    if @user
      @challenges = @user.challenges
    else
      redirect_to root_path, alert: 'Utente non trovato. Effettua il login.'
    end
  end
end
