class ApplicationController < ActionController::Base
  private

  def current_user
    @current_user ||= User.find_by(id: session[:userinfo]['user_id']) if session[:userinfo]
  end
end
