class ApplicationController < ActionController::Base
  before_action :set_player_name
  private
  def set_player_name
    @player_name = "Player_#{SecureRandom.hex(4)}"
    @player = Player.find_or_create_by(name: @player_name)
    session[:player_id] ||= @player.id
    cookies[:player_id] = {
      :value => session[:player_id],
    }

  end
end
