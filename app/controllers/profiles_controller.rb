class ProfilesController < ApplicationController
  def admin_profile
    @challenges = Challenge.where(status: -1)
    @non_admin_users = User.where(is_admin: false).order('users.name')
  end

  def promote_to_admin
    user = User.find(params[:id])
    if user.update(is_admin: true)
      redirect_to challenges_path, notice: "#{user.name} è stato promosso a admin."
    else
      redirect_to challenges_path, alert: "Errore nella promozione di #{user.name}."
    end
  end

  def user_profile
    @accepted_challenges = Challenge.where(status: 1, user_id: session[:user_id])
    @rejected_challenges = Challenge.where(status: 0, user_id: session[:user_id])
  end
end
