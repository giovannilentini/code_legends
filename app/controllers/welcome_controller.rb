class WelcomeController < ApplicationController
  def index
    if session[:userinfo].present?
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
    Rails.logger.debug "User info: #{@user.inspect}"
  end
end
