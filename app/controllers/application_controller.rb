class ApplicationController < ActionController::Base
  before_action :set_current_user
  helper_method :current_user


  def authenticate_user!
    unless current_user
      redirect_to root_path, alert: "You need to sign in before continuing."
    end
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
