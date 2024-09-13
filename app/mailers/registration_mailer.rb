class RegistrationMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def email_confirmation(user)
    @user = user
    @confirmation_link = confirm_email_url(token: @user.confirmation_token)
    mail(to: @user.email, subject: 'Email Confirmation')
  end
end