class RegisteredUsersController < ApplicationController
  before_action :set_user, only: [:show]
  def show
    authorize! :read, RegisteredUser
  end

  def edit
    @user = RegisteredUser.find_by(id: params[:id])
  end

  def create
    @user = RegisteredUser.new(user_auth)

    existing_user = RegisteredUser.find_by(email: @user.email)
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
        @user.generate_confirmation_token
        RegistrationMailer.email_confirmation(@user).deliver_now
        flash[:notice]="Please check your email to confirm your account."
        redirect_to root_path
      end
    end
  end

  def confirm_email
    unless params[:token].nil?
      user = RegisteredUser.find_by(confirmation_token: params[:token])
      if user.present?
        user.update(email_confirmed_at: Time.current, confirmation_token: nil)
        flash[:notice] = "Your email has been confirmed."
        redirect_to login_path
      else
        flash[:alert] = "Invalid or expired token."
        redirect_to root_path
      end
    end
  end

  def update
    @user = RegisteredUser.find_by(id: params[:id])
    if @user.update!(user_settings)
      flash[:success] = "Profile updated"
      redirect_to user_path(@user)
    else
      flash.now[:alert] = "Error updating profile"
      render user_path(@user)
    end
  end
  private

  def set_user
    @user_profile = RegisteredUser.find_by(id: params[:id])
    @accepted_challenges = ChallengeProposal.where(status: "accepted", user: @user_profile)
    @rejected_challenges = ChallengeProposal.where(status: "rejected", user: @user_profile)

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
