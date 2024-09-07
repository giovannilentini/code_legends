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
    response = CodeExecutionService.execute_code(params[:code], params[:language])
    unless response.nil?
      @result = JSON.parse(response.body)["Result"]
      unless @result
        @result = JSON.parse(response.body)["Errors"]
      end
    end
    render json: { output:  @result}
  end

  def surrender

    match = Match.find_by(id: params[:match_id])
    user = current_user

    winner =  user == match.player_1 ? match.player_2 : match.player_1
    loser =  match.player_2 == winner ? match.player_1 : match.player_2

    MatchmakingQueueService.remove_from_queue(loser)
    MatchmakingQueueService.remove_from_queue(winner)
    match.chat_messages.destroy_all
    match.update(status: "finished", winner_id: winner.id)
    ActionCable.server.broadcast "match_#{match.id}", { action: 'redirect_to_play_now'}
    ActionCable.server.broadcast "match_#{match.id}", { action: 'redirect_to_play_now'}
  end

  private
  def set_match
    @match = Match.find_by(id: params[:id] || params[:match_id])
    if @match.challenge_id.nil?
      @challenge = Challenge.find(Challenge.where(language: @match.language).pluck(:id).sample)
      @match.update(:challenge_id => @challenge.id)
    else
      @challenge = Challenge.find_by(id: @match.challenge_id)
    end
  end

  def set_challenge

  end
end
