class PasswordResetsController < ApplicationController
  def new
    # This is the form where users request password reset
  end

  def create

    @user = User.find_by(email: params[:email])
    if @user
      if @user.has_auth0?
         flash[:alert] = "User registered with #{@user.provider} oauth"
        redirect_to login_path
      else
        @user.generate_password_reset_token!
        p "USER TOKEN"
        p @user.reset_token
        PasswordMailer.with(user: @user).password_reset.deliver_now
        flash[:notice] = "Password reset instructions sent to your email"
        redirect_to root_path
      end
    else
      flash[:alert] = "Email not found"
      redirect_to root_path
    end
  end

  def edit
    unless params[:token].nil?
      @user = User.find_by(reset_token: params[:token])
      @reset_token = @user.reset_token
      unless @user && @user.password_reset_token_valid?
        flash[:alert] = "Invalid or expired reset link"
        redirect_to password_reset_path
      end
    end
  end

  def update
    @user = User.find_by(reset_token: params[:token])
    if @user && @user.update(password_params)

      @user.clear_password_reset_token!
      flash[:notice] = "Password has been reset!"
      redirect_to login_path
    else
      flash[:alert] = "Password reset failed"
      render :edit
    end
  end

  private

  def password_params
    params.require(:user).permit(:password)
  end


end