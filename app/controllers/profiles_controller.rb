class ProfilesController < ApplicationController
  def admin_profile
    @challenges = Challenge.where(status: -1)
  end

  def update_status
    @challenge = Challenge.find(params[:id])
    @challenge.status = params[:status]

    if params[:status].to_i == 0
      @challenge.rejection_reason = params[:rejection_reason]
    else
      @challenge.rejection_reason = nil
    end

    if @challenge.save
      redirect_to admin_profile_path, notice: 'Stato aggiornato con successo.'
    else
      redirect_to admin_profile_path, alert: 'Errore nell\'aggiornamento dello stato.'
    end
  end

  def user_profile
    @accepted_challenges = Challenge.where(status: 1)
    @rejected_challenges = Challenge.where(status: 0)
  end
end
