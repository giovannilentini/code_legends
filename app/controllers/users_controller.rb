class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  befpre_action :authorize_user, only: [:show]

  def show
    @user = User.find(params[:id])
    @accepted_challenges = @user.challenges.accepted
    @rejected_challenges = @user.challenges.rejected
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user
    authorize! :read, @user
end
