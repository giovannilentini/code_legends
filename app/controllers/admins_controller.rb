class AdminsController < ApplicationController

  def show
    authorize! :read, :admin_page

    @challenges_proposals = ChallengeProposal.where(status: "pending")
    @non_admin_users = User.where(is_admin: false, guest:false).order('users.username')
  end

  def promote_to_admin
    user = User.find(params[:id])
    if user.update(is_admin: true)
      flash[:notice]="#{user.username} è stato promosso a admin."
      redirect_to admin_path(user.id)
    else
      flash[:alert]="Errore nella promozione di #{user.username}."
      redirect_to admin_path(user.id)
    end
  end


end