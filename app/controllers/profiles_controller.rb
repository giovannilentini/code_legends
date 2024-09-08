class ProfilesController < ApplicationController
  def admin_profile
    @challenges_proposals = ChallengeProposal.where(status: "pending")
    @non_admin_users = User.where(is_admin: false, guest:false).order('users.username')
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
    @user = User.find(session[:user_id])
    @accepted_challenges = ChallengeProposal.where(status: "accepted", user: @user)
    @rejected_challenges = ChallengeProposal.where(status: "reject", user: @user)
    @pending_challenges = ChallengeProposal.where(status: "pending", user: @user)
    @friend_requests = FriendRequest.where(friend_id: @user.id)
    @challenge_requests = current_user.received_challenge_requests
  end
end
