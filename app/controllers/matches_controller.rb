class MatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_match
  def show
    # TODO
    #@code_template = retrieve_code_template(@challenge_code_template, @match.language)
    # Ensure that only the participants can view the match
    unless [@match.player_1, @match.player_2].include?(current_user)
      redirect_to root_path, alert: 'You are not authorized to view this match.'
    end
  end
  def execute_code
    selected_language = @match.language
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
    @match = Match.find_by(id: params[:id])
  end

  def set_challenge
    @challenge= Challenge.find_by(id: 1)
    @challenge_code_template = CodeTemplate.find_by(challenge_id: @challenge.id)
  end

  def retrieve_code_template(code_template, language)
    if language == "python3"
      code_template.python
    elsif language == "java"
      code_template.java
    elsif language=="cpp"
      code_template.cpp
    end
  end
end
