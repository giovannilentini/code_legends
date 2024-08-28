class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def show
    @user = User.find(params[:id])
    @accepted_challenges = @user.challenges.accepted
    @rejected_challenges = @user.challenges.rejected
    @is_friend = current_user.friends.include?(@user) || current_user.inverse_friends.include?(@user)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
