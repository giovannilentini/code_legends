class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :set_user, only: [:show]
  def show

  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to user_path(@user)
    else
      flash.now[:alert] = "Error updating profile"
      render :edit
    end
  end
  private

  def set_user
    @user_profile = User.find_by(id: params[:id])
    @accepted_challenges = ChallengeProposal.where(status: "accepted", user: @user_profile)
    @rejected_challenges = ChallengeProposal.where(status: "reject", user: @user_profile)

    if @user_profile == current_user
      @pending_challenges = ChallengeProposal.where(status: "pending", user: @user_profile)
    end
  end
  def user_params
    params.require(:user).permit(:name, :email, :profile_image)
  end
end
