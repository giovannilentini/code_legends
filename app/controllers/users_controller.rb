class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  def show

  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def create
    if @current_user
      flash[:notice] = "You are already logged in."
      redirect_to root_path
    end

    @user = User.new(user_auth)
    @user.guest=false

    existing_user = User.find_by(email: @user.email)
    if existing_user
      if existing_user.has_auth0?
        flash[:alert] = "User with mail #{@user.email} already registered with #{existing_user.provider} oauth"
        redirect_to root_path
      else
        flash[:alert] = "User with mail #{@user.email} already exists"
        redirect_to root_path
      end
    else
      if @user.save!
        session[:user_id] = @user.id
        flash[:success]="User created succesfully"
        redirect_to root_path
      end
    end
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update(user_settings)
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
  def user_settings
    params.require(:user).permit(:name, :email, :profile_image)
  end

  def user_auth
    params.require(:user).permit(:username, :email, :password)
  end
end
