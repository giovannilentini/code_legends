class ProfilesController < ApplicationController
  def admin_profile
    @challenges = Challenge.where(status: -1)
    @non_admin_users = User.where(is_admin: false).order('users.username')
  end

  def promote_to_admin
    user = User.find(params[:id])
    if user.update(is_admin: true)
      redirect_to challenges_path, notice: "#{user.username} è stato promosso a admin."
    else
      redirect_to challenges_path, alert: "Errore nella promozione di #{user.username}."
    end
  end

  def user_profile
    @accepted_challenges = Challenge.where(status: 1, user_id: session[:user_id])
    @rejected_challenges = Challenge.where(status: 0, user_id: session[:user_id])
  end

  class UsersController < ApplicationController
    before_action :set_user, only: [:show]

    def show
      @current_user = current_user
      @is_friend = @current_user.friends.include?(@user) || @current_user.inverse_friends.include?(@user)
    end

    private

    def set_user
      @user = User.find(params[:id])
    end
  end

end
