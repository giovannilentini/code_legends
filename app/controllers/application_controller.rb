class ApplicationController < ActionController::Base
  before_action :set_player_name
  before_action :set_current_user
  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  private
  def set_player_name
    @player_name = "Player_#{SecureRandom.hex(4)}"
    @player = Player.find_or_create_by(name: @player_name)
    session[:player_id] ||= @player.id
    cookies[:player_id] = {
      :value => session[:player_id],
    }

  end

  def set_current_user
    @current_user = current_user
  end
end
