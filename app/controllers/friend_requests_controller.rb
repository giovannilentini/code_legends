class FriendRequestsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @user = User.find(params[:user_id])

    if Friendship.exists?(user_id: current_user.id, friend_id: @user.id) || Friendship.exists?(user_id: @user.id, friend_id: current_user.id)
      flash[:alert] = "Siete già amici."
      redirect_to root_path
    elsif FriendRequest.exists?(user_id: current_user.id, friend_id: @user.id) || FriendRequest.exists?(user_id: @user.id, friend_id: current_user.id)
      flash[:alert] = "C'è già una richiesta di amicizia in sospeso."
      redirect_to root_path
    else
      @friend_request = FriendRequest.new(user_id: current_user.id, friend_id: @user.id)

      if @friend_request.save
        flash[:notice] = "Richiesta di amicizia inviata con successo."
        redirect_to root_path
      else
        flash[:alert] = "Errore nell'invio della richiesta di amicizia."
        render :new
      end
    end
  end

  def accept
    @friend_request = FriendRequest.find(params[:id])

    Friendship.create(user_id: @friend_request.user_id, friend_id: @friend_request.friend_id)
    Friendship.create(user_id: @friend_request.friend_id, friend_id: @friend_request.user_id)

    @friend_request.destroy

    redirect_to personal_profile_path(current_user), notice: 'Richiesta di amicizia accettata.'
  end

  def reject
    @friend_request = FriendRequest.find(params[:id])

    @friend_request.destroy

    redirect_to personal_profile_path(current_user), notice: 'Richiesta di amicizia rifiutata.'
  end
end
