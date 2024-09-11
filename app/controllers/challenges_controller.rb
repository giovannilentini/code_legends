class ChallengesController < ApplicationController
  load_and_authorize_resource
  def new
    @challenge_proposal = ChallengeProposal.find_by(id: params[:challenge_proposal_id])
    @challenge = Challenge.build
  end
  def edit
    authorize! :read, Challenge
    @challenge = Challenge.find(params[:id])
  end

  def create
    @challenge = Challenge.new(challenge_params)
    authorize! :create, @challenge  # Solo utenti registrati possono creare una sfida
    if @challenge.save
      ChallengeProposal.find_by(id: @challenge.challenge_proposal_id).update(status: "accepted")
      flash[:success] = "Challenge successfully created!"
      redirect_to admin_path(current_user)
    else
      Rails.logger.error(@challenge.errors)
      flash[:alert] = "Something went wrong. Please try again."
      redirect_to admin_path(current_user)
    end
  end

  def update
    # Update the challenge with the provided parameters
    if @challenge.update(challenge_params)
      # Redirect to the challenge edit page or any other appropriate page
      redirect_to root_path, notice: 'Challenge was successfully updated.'
    else
      # Render the edit form again with error messages
      redirect_to edit_challenge_path(@challenge)
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