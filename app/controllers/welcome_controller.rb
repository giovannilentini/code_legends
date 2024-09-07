class WelcomeController < ApplicationController
  before_action :set_languages, only: [:home, :find_opponent]

  def home
    if current_user
      @accepted_challenges = Challenge.where(status: 1, user_id: session[:user_id])
      @rejected_challenges = Challenge.where(status: 0, user_id: session[:user_id])
      @user = User.find(session[:user_id])
      @friend_requests = FriendRequest.where(friend_id: @user.id)
      @challenge_requests = current_user.received_challenge_requests
    end
  end

  def find_opponent
    player = User.find_by(id: session[:user_id])
    if player
      MatchmakingQueueService.new(player).add_to_queue(@selected_language)
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("waiting_modal", partial: "matchmaking_queue/waiting_modal") }
        format.html { render :home } # Render the home view without redirect
      end
    end
  end

  def cancel
    player = User.find_by(id: session[:user_id])
    MatchmakingQueueService.remove_from_queue(player)
    redirect_to root_path, notice: "Ricerca avversario annullata."
  end

  private

  def set_languages
    @languages = ['Python3', 'Java', 'Cpp']
    @selected_language = params[:language].presence || 'python3'
  end
end
