class GuestsController < ApplicationController
    def create
      if session[:user_id]
        guest_user = User.find_by(id: session[:user_id], guest: true)
      end
  
      unless guest_user
        guest_user = Guest.create
        session[:user_id] = guest_user.id
        cookies[:user_info] = { value: guest_user.id, expires: 1.year.from_now }
      end

      redirect_to root_path
    end
    private
  end
  