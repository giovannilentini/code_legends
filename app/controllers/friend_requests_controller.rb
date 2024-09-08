class FriendRequestsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :accept, :reject]
  before_action :set_friend_request, only: [:accept, :reject]
  load_and_authorize_resource only: [:create, :accept, :reject]
  
  def create
    authorize! :create, FriendRequest        # Solo utenti registrati possono inviare richieste di amicizia
    
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
    authorize! :manage, @friend_request

    @friend_request = FriendRequest.find(params[:id])

    Friendship.create(user_id: @friend_request.user_id, friend_id: @friend_request.friend_id)
    Friendship.create(user_id: @friend_request.friend_id, friend_id: @friend_request.user_id)

    @friend_request.destroy

    redirect_to personal_profile_path(current_user), notice: 'Richiesta di amicizia accettata.'
  end

  def reject
    authorize! :manage, @friend_request

    @friend_request = FriendRequest.find(params[:id])

    @friend_request.destroy

    redirect_to personal_profile_path(current_user), notice: 'Richiesta di amicizia rifiutata.'
  end
end
