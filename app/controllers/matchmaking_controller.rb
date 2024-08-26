class MatchmakingController < ApplicationController
  def play_now
    @languages = ['Python3', 'Java', 'Cpp']
    @selected_language = params[:language].presence || 'python3'
    session[:selected_language] = @selected_language
  end

  def find_opponent

    @selected_language = session[:selected_language]
    player = User.find_or_create_by(id: session[:user_id])
    if player
      MatchmakingQueueService.add(player, @selected_language)
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("waiting_modal", partial: "matchmaking/waiting_modal") }
        format.html { redirect_to play_now_path } # fallback in case Turbo isn't supported
      end
    end
  end

  def cancel
    player = User.find_by(id: session[:user_id])
    language = session[:selected_language]
    MatchmakingQueueService.remove(player, language)
    redirect_to play_now_path, notice: "Ricerca avversario annullata."
  end

end
