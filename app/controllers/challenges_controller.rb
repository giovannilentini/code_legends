class ChallengesController < ApplicationController

  def new
    @challenge = Challenge.new
    @challenge.test_cases.build
  end

  def create
    @challenge = current_user.challenges.build(challenge_params)
    if @challenge.save
      redirect_to @challenge, notice: 'Sfida creata con successo.'
    else
      render :new
    end
  end

  private

  def challenge_params
    params.require(:challenge).permit(:description, test_cases_attributes: [:input_example, :expected_output])
  end

  def update_status
    @challenge = Challenge.find(params[:id])
    @challenge.status = params[:status]

    if @challenge.status.to_i == 0
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
end
