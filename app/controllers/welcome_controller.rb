class WelcomeController < ApplicationController
  def index
    if session[:userinfo].present?
      render 'logged_index'
    else
      render 'index'
    end
  end

    def logged_index
      @user = session[:userinfo]
      Rails.logger.debug "User info: #{@user.inspect}"
    end
end
