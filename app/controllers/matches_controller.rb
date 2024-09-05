class MatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_match
  def show
    # Ensure that only the participants can view the match
    unless [@match.player_1, @match.player_2].include?(current_user)
      redirect_to root_path, alert: 'You are not authorized to view this match.'
    end
  end
  def execute_code
    selected_language = Match.find_by(id: params[:match_id]).language
    response = JdoodleService.execute_code(params[:code], selected_language)
    unless response.nil?
      if response.code == "200"
        @result = JSON.parse(response.body)["output"]
      else
        @result = JSON.parse(response.body)["error"]
      end
    end
    render json: { output:  @result}
  end

  def surrender

    match = Match.find_by(id: params[:match_id])
    user = current_user

    winner =  user == match.player_1 ? match.player_2 : match.player_1

    match.update(status: "finished", winner_id: winner.id)
    MatchmakingQueueService.remove_from_queue(user)
    MatchmakingQueueService.remove_from_queue(winner)
    ActionCable.server.broadcast "match_#{match.id}", { action: 'redirect_to_play_now'}
    ActionCable.server.broadcast "match_#{match.id}", { action: 'redirect_to_play_now'}
  end

  private
  def set_match
    @match = Match.find_by(id: params[:id])
  end
end
