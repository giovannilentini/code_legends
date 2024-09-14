class FriendRequestsController < ApplicationController
  load_and_authorize_resource only: [:create, :accept, :reject]

  def create
    @user = User.find(params[:user_id])

    if Friendship.exists?(user_id: current_user.id, friend_id: @user.id) || Friendship.exists?(user_id: @user.id, friend_id: current_user.id)
      flash[:alert] = "You are already friends with that user"
      redirect_to root_path
    elsif FriendRequest.exists?(user_id: current_user.id, friend_id: @user.id) || FriendRequest.exists?(user_id: @user.id, friend_id: current_user.id)
      flash[:alert] = "Pending request already exists"
      redirect_to root_path
    else
      @friend_request = FriendRequest.new(user_id: current_user.id, friend_id: @user.id)

      if @friend_request.save
        ActionCable.server.broadcast 'notifications_channel', { has_notifications: true }
        flash[:notice] = "Friend request sent."
        redirect_to root_path
      else
        flash[:alert] = "Cannot send friend request."
        render :new
      end
    end
  end

  def accept
    @friend_request = FriendRequest.find(params[:id])

    Friendship.create(user_id: @friend_request.user_id, friend_id: @friend_request.friend_id)
    Friendship.create(user_id: @friend_request.friend_id, friend_id: @friend_request.user_id)
    @friend_request.destroy
    flash[:notice]= 'Friend request accepted.'
    redirect_to root_path
  end

  def reject
    @friend_request = FriendRequest.find(params[:id])
    @friend_request.destroy
    flash[:notice]= 'Friend request rejected.'
    redirect_to root_path
  end
end
