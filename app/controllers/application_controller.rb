class ApplicationController < ActionController::Base
  before_action :set_current_user
  helper_method :current_user, :user_signed_in?

  rescue_from CanCan::AccessDenied do |exception|
    
    flash[:alert] = "Accesso negato: #{exception.message}"
    redirect_to root_path 

  end
  def user_signed_in?
    current_user.present?
  end


  def authenticate_user!
    if user_signed_in? && !current_user.guest?
      return
    end
    redirect_to auth0_login_url, alert: "You need to sign in before continuing."
  end
  
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    else
    end
  end

  private
  
  def set_current_user
    @current_user = current_user  
  end
end
