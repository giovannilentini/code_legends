class MatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_match, only: [:show, :execute_code, :surrender, :timeout]

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
      @error = JSON.parse(response.body)["Errors"]

      if @result
          @output = @result
          if @result.strip == "Winner"
            loser = current_user == @match.player_1 ? @match.player_2 : @match.player_1
            set_winner(current_user, loser, @match)
          end
      else
        @output = @error
      end
    end
    render json: { output:  @output}
  end

  def surrender
    winner =  current_user == @match.player_1 ? @match.player_2 : @match.player_1
    loser =  @match.player_2 == winner ? @match.player_1 : @match.player_2
    set_winner(winner, loser, @match, true)
  end

  def timeout
    if @match.timer_expires_at && Time.current >= @match.timer_expires_at
      @match.update(status: "finished", winner_id: nil)
      ActionCable.server.broadcast "match_#{@match.id}", { status: "timeout", message: "The match ended in a draw." }
    end

    head :ok
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

    unless @match.timer_expires_at
      @match.update(timer_expires_at: 10.seconds.from_now)
    end
  end

  def set_winner(winner, loser, match, surrendered=false)
    MatchmakingQueueService.remove_from_queue(loser)
    MatchmakingQueueService.remove_from_queue(winner)
    match.chat_messages.destroy_all
    match.update(status: "finished", winner_id: winner.id)

    difficulty = Challenge.find_by(id: match.challenge_id).difficulty

    LeaderboardService.update_score(winner.id, calculate_lp_gain(difficulty))
    LeaderboardService.update_score(loser.id, -calculate_lp_loss(difficulty, surrendered))

    ActionCable.server.broadcast "submission_#{match.id}_#{winner.id}", { status: 'winner', message: "You won #{calculate_lp_gain(difficulty)}LP"}
    ActionCable.server.broadcast "submission_#{match.id}_#{loser.id}", { status: 'loser', message: "You lost #{calculate_lp_loss(difficulty, surrendered)}LP"}
  end

  def calculate_lp_gain(difficulty)
    if difficulty == "easy"
      return 10
    elsif difficulty == "medium"
      return 15
    else
      return 25
    end
  end

  def calculate_lp_loss(difficulty, surrendered)

    penalty = surrendered ? 5 : 0

    if difficulty == "easy"
      return 20 + penalty
    elsif difficulty == "medium"
      return 10 + penalty
    else
      return 5 + penalty
    end
  end
end
