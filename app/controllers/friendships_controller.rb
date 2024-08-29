class FriendshipsController < ApplicationController
  def create
    friend = User.find(params[:id])
    current_user.friends << friend unless current_user.friends.include?(friend) || friend == current_user
    redirect_to user_profile_path(friend), notice: 'Amico aggiunto con successo!'
  end
end
