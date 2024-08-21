class ProfilesController < ApplicationController
  def admin_profile
    @challenges = Challenge.where(status: -1)
  end

  def user_profile
    @accepted_challenges = Challenge.where(status: 1, user_id: session[:user_id])
    @rejected_challenges = Challenge.where(status: 0, user_id: session[:user_id])
  end
end
