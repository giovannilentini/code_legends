module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      current_user = find_verified_user
    end

    private
    def find_verified_user

      @current_user = User.find_by(:id => cookies[:user_info])
      if @current_user
        @current_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
