class WelcomeController < ApplicationController
  before_action :set_languages
  def home
    unless current_user.nil?
      unless current_user.guest?
        @user = current_user
        @friend_requests = FriendRequest.where(friend_id: @user.id)
        @challenge_requests = ChallengeRequest.where(friend_id: @user.id)
      end
    end
  end

  private
  def set_languages
    @languages = ['Python3', 'Java', 'JavaScript']
    @selected_language = params[:language].presence || 'python3'
  end
end
