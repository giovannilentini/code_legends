class AdminsController < ApplicationController

  def show
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


end