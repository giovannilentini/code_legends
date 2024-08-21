class ProfilesController < ApplicationController
  def admin_profile
    @challenges = Challenge.where(status: -1)
  end

  def user_profile
    @accepted_challenges = Challenge.where(status: 1)
    @rejected_challenges = Challenge.where(status: 0)
  end
end
