class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin, only: [:admin_profile, :promote_to_admin]

  def admin_profile
    @challenges_proposals = ChallengeProposal.where(status: "pending")
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
    if current_user.guest?
      flash[:alert] = "You must be logged in to edit your profile."
      redirect_to root_path
    else
    @user = User.find(session[:user_id])
    @accepted_challenges = ChallengeProposal.where(status: "accepted", user: @user)
    @rejected_challenges = ChallengeProposal.where(status: "reject", user: @user)
    @pending_challenges = ChallengeProposal.where(status: "pending", user: @user)
    @friend_requests = FriendRequest.where(friend_id: @user.id)
    @challenge_requests = current_user.received_challenge_requests
    end
  end
  private

  def authorize_admin
    unless current_user.admin?
      flash[:alert] = "Accesso negato. Solo gli admin possono accedere a questa sezione."
      redirect_to root_path
    end
  end

  def authenticate_user!
    unless session[:user_id] # Verifica se l'ID dell'utente è presente nella sessione
       redirect_to root_path ,alert: "You must be logged in to see your profile."
    end
  end
end
