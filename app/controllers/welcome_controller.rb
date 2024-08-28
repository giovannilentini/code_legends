class WelcomeController < ApplicationController
  def home

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
