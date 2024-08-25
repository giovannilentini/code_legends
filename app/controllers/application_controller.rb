class ApplicationController < ActionController::Base
  before_action :set_player_name
  private
  def set_player_name
    @player_name = "Player_#{SecureRandom.hex(4)}"
    session[:player_name] ||= @player_name
    cookies[:player_name] = {
      :value => session[:player_name],
    }

  end
end
