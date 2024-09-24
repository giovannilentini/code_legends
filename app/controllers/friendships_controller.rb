class FriendshipsController < ApplicationController
  def create
      friend = RegisteredUser.find(params[:id])
      if friend.nil?
        redirect_to root_path, alert: 'User not found'
      elsif friend == current_user
        redirect_to root_path, alert: 'You cannot add yourself as a friend.'
      elsif current_user.friends.include?(friend)
        redirect_to user_path(friend), alert: 'You are already friends.'
      else
      current_user.friends << friend
      redirect_to user_path(friend), notice: 'Successfully friend!'
      end
    end
end
