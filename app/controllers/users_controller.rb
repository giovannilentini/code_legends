class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :set_user, only: [:show]
  before_action :authorize_user
  before_action :authenticate_user!

  def show
    if current_user.guest?
      flash[:alert] = "You must be logged in to see your profile."
      redirect_to root_path
    @user = User.find(params[:id])
    @accepted_challenges = @user.challenges.accepted
    @rejected_challenges = @user.challenges.rejected
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authenticate_user!
    unless session[:user_id] # Verifica se l'ID dell'utente è presente nella sessione
       redirect_to root_path ,alert: "You must be logged in to see your profile."
    end
  end
end
