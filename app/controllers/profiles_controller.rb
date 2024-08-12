class ProfilesController < ApplicationController
  def admin_profile
    @challenges = Challenge.where(status: -1)
  end

  def update_status
    @challenge = Challenge.find(params[:id])
    if @challenge.update(status: params[:status])
      redirect_to admin_profile_path, notice: 'Status aggiornato con successo.'
    else
      redirect_to admin_profile_path, alert: 'Errore nell\'aggiornamento dello status.'
    end
  end

    def user_profile
      @accepted_challenges = Challenge.where(status: 1)
      @rejected_challenges = Challenge.where(status: 0)
    end
end
