class ChallengeProposalsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource


  def show

  if current_user.guest?
      flash[:alert] = "You must be logged in to create a challenge proposal."
      redirect_to root_path
    @challenge_proposal = ChallengeProposal.find(params[:id])
    @test_cases = @challenge_proposal.test_cases
  end
end


  def new
    if current_user.guest?
      flash[:alert] = "You must be logged in to create a challenge proposal."
      redirect_to root_path
    else
      @challenge_proposal = ChallengeProposal.new
    end
  end

  def create
    @challenge_proposal = ChallengeProposal.new(challenge_proposal_params)
    @challenge_proposal.user = current_user
    if @challenge_proposal.save
      flash[:success] = "Challenge Proposal created!"
      redirect_to challenge_proposal_path(@challenge_proposal)
    else
      flash[:alert]="An error occurred while creating the challenge proposal, retry."
      redirect_to new_challenge_proposal_path
    end

  end

  def reject

    reject_motivation = params[:reject_motivation]
    if reject_motivation != ""
      @challenge_proposal = ChallengeProposal.find(params[:id])
      if @challenge_proposal.update(status: "rejected", rejection_reason: reject_motivation)
        flash[:success] = "Proposal rejected"
        redirect_to admin_profile_path(current_user)
      else
        flash[:alert]="An error occurred while rejecting the proposal, retry."
        redirect_to admin_profile_path(current_user)
      end
    else
      flash[:alert]="Rejection motivation cannot be null"
      redirect_to admin_profile_path(current_user)
    end

  end
  def destroy
    @challenge_proposal = ChallengeProposal.find(params[:id])
    @challenge_proposal.destroy
    redirect_to root_path
  end
  private
  def challenge_proposal_params
    params.require(:challenge_proposal).permit(:title, :description, :test_cases, :language)
  end

  def authenticate_user!
    unless session[:user_id] # Verifica se l'ID dell'utente è presente nella sessione
       redirect_to root_path ,alert: "You must be logged in to create a challenge proposal."
    end
  end
end
