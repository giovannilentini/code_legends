class ProfilesController < ApplicationController
  def admin_profile
    @challenges = Challenge.where(status: -1)
    @non_admin_users = User.where(is_admin: false).order('users.username')
  end

  def promote_to_admin
    user = User.find(params[:id])
    if user.update(is_admin: true)
      redirect_to admin_profile_path, notice: "#{user.username} è stato promosso a admin."
    else
      redirect_to admin_profile_path, alert: "Errore nella promozione di #{user.username}."
    end
  end

  def user_profile
    @accepted_challenges = Challenge.where(status: 1, user_id: session[:user_id])
    @rejected_challenges = Challenge.where(status: 0, user_id: session[:user_id])

    @user = User.find(session[:user_id])
    @friend_requests = FriendRequest.where(friend_id: @user.id)
    @challenge_requests = current_user.received_challenge_requests
  end
end
