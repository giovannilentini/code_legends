class ChallengesController < ApplicationController
  before_action :set_challenge, only: [:update_status]
  load_and_authorize_resource except: [:new, :create] 

  def new
    @challenge_proposal = ChallengeProposal.find_by(id: params[:challenge_proposal_id])
    @challenge = Challenge.build
  end

  def show

  end

  def create
    @challenge = Challenge.new(challenge_params)

    authorize! :create, Challenge  # Solo utenti registrati possono creare una sfida


    if @challenge.save
      ChallengeProposal.find_by(id: @challenge.challenge_proposal_id).update(status: "accepted")
      flash[:success] = "Challenge successfully created!"
      redirect_to admin_profile_path
    else
      Rails.logger.error(@challenge.errors)
      flash[:alert] = "Something went wrong. Please try again."
      redirect_to admin_profile_path
    end
  end

  def update_status
    authorize! :approve, @challenge 
    @challenge.status = params[:status]

    if @challenge.status.to_i == 0
      @challenge.rejection_reason = params[:rejection_reason]
    else
      @challenge.rejection_reason = nil
    end

    if @challenge.save
      redirect_to admin_profile_path, notice: 'Updated correctly.'
    else
      redirect_to admin_profile_path, alert: 'Error updating the status.'
    end
  end

  private

  def set_challenge
    @challenge = Challenge.find(params[:id])
  end
  
  def challenge_params
    params.require(:challenge).permit(:title, :description, :language, :difficulty, :code_template, :test_template, :challenge_proposal_id)
  end
  
end  