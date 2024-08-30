class FriendRequestsController < ApplicationController
  def create
    @friend_request = FriendRequest.new(user_id: current_user.id, friend_id: params[:user_id])

    if @friend_request.save
      flash[:notice] = "Richiesta di amicizia inviata."
    else
      flash[:alert] = "Errore nell'invio della richiesta di amicizia."
    end

    redirect_to user_profile_path(params[:user_id])
  end

  def accept
    @friend_request = FriendRequest.find(params[:id])

    Friendship.create(user_id: @friend_request.user_id, friend_id: @friend_request.friend_id)

    @friend_request.destroy

    redirect_to personal_profile_path(current_user), notice: 'Richiesta di amicizia accettata.'
  end

  def reject
    @friend_request = FriendRequest.find(params[:id])

    @friend_request.destroy

    redirect_to personal_profile_path(current_user), notice: 'Richiesta di amicizia rifiutata.'
  end
end
