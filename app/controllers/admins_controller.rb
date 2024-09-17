class AdminsController < ApplicationController

  def show
    authorize! :admin, :all

    @challenges_proposals = ChallengeProposal.where(status: "pending")
    @non_admin_users = User.where(is_admin: false, guest:false).order('users.username')
    @challenges = Challenge.all
  end

  def promote_to_admin
    authorize! :admin, :all
    user = User.find(params[:admin_id])
    if user.update(is_admin: true)
      flash[:notice]="#{user.username} has been promoted."
      redirect_to admin_path(user.id)
    else
      flash[:alert]="Error promoting #{user.username}."
      redirect_to admin_path(user.id)
    end
  end


end