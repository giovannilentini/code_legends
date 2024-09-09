class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :set_user, only: [:show]
  before_action :authorize_user
  before_action :authenticate_user!

  def show

  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'Profilo aggiornato con successo.'
    else
      flash.now[:alert] = 'Errore nell\'aggiornamento del profilo.'
      render :edit
    end
  end
  private

  def set_user
    @user = User.find(session[:user_id])
    @accepted_challenges = ChallengeProposal.where(status: "accepted", user: @user)
    @rejected_challenges = ChallengeProposal.where(status: "reject", user: @user)
    @pending_challenges = ChallengeProposal.where(status: "pending", user: @user)
    @friend_requests = FriendRequest.where(friend_id: @user.id)
    @challenge_requests = current_user.received_challenge_requests
  end

  def authenticate_user!
    unless session[:user_id] # Verifica se l'ID dell'utente è presente nella sessione
       redirect_to root_path ,alert: "You must be logged in to see your profile."
    end
  end
end
