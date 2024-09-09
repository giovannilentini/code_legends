class MatchmakingQueueController < ApplicationController
  before_action :authenticate_user!
  before_action :set_languages

  def play_now
    authorize! :read, :play_now
    @player = User.find_by(id: session[:user_id])
    @last_matches = Match.where(player_1_id: @player.id).or(Match.where(player_2_id: @player.id))
                         .order(updated_at: :desc).limit(5)

    @match_details = @last_matches.map do |match|
      opponent_id = match.player_1_id == current_user.id ? match.player_2_id : match.player_1_id
      match_result = match.winner_id == current_user.id ? "Win" : "Lose"
      {
        opponent: User.find_by(id: opponent_id).username,
        result: match_result,
        date: match.updated_at.strftime("%B %d, %Y")
      }
    end
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


  def authenticate_user!
    unless session[:user_id] # Verifica se l'ID dell'utente è presente nella sessione
       redirect_to root_path ,alert: "You must be logged in or be guest to play now!."
    end
  end
end


