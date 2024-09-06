class MatchmakingQueueController < ApplicationController

  before_action :set_languages
  def play_now
    @player = User.find_by(id: session[:user_id])
  end

  def find_opponent
    player = User.find_by(id: session[:user_id])
    if player
      MatchmakingQueueService.new(player).add_to_queue(@selected_language)
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("waiting_modal", partial: "matchmaking_queue/waiting_modal") }
        format.html { redirect_to play_now_path }
      end
    end
  end

  def cancel
    player = User.find_by(id: session[:user_id])
    language = session[:selected_language]
    MatchmakingQueueService.remove_from_queue(player)
    redirect_to play_now_path, notice: "Ricerca avversario annullata."
  end
  private
  def set_languages
    @languages = ['Python3', 'Java', 'Cpp']
    @selected_language = params[:language].presence || 'python3'
  end
end
