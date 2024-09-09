class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :authorize_read, only: [:show]
  before_action :authorize_update, only: [:update, :edit]
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

  def authorize_read
    authorize! :read, @user
  end
  def authorize_update
    authorize! :update, @user
  end

end
