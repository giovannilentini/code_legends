class WelcomeController < ApplicationController
  before_action :set_languages

  def home
    if current_user
      @user = User.find(session[:user_id])
      @friend_requests = FriendRequest.where(friend_id: @user.id)
      @challenge_requests = current_user.received_challenge_requests
    end
  end

  private
  def set_languages
    @languages = ['Python3', 'Java', 'Cpp']
    @selected_language = params[:language].presence || 'python3'
  end
end
