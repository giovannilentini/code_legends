class ApplicationController < ActionController::Base
  before_action :set_current_user
  helper_method :current_user, :user_signed_in?

  def user_signed_in?
    current_user.present?
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert]="You are not authorized to access this page."
    redirect_to root_path
  end

  def authenticate_user!
    if user_signed_in? && !current_user.guest?
      return
    end
    flash[:alert] = "Please sign in."
    redirect_to auth0_login_url
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
