class WelcomeController < ApplicationController
  def home
    if current_user
      @accepted_challenges = Challenge.where(status: 1, user_id: session[:user_id])
      @rejected_challenges = Challenge.where(status: 0, user_id: session[:user_id])
      @user = User.find(session[:user_id])
      @friend_requests = FriendRequest.where(friend_id: @user.id)
      @challenge_requests = current_user.received_challenge_requests
    end
  end
end
