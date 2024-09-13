class PasswordMailer < ApplicationMailer
  def password_reset
    @user = params[:user]
    @reset_url = password_reset_edit_url(token: @user.reset_token)
    mail(to: @user.email, subject: "Password Reset Instructions")
  end
end