class ChallengeProposalsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :new]  # Assicurati che solo utenti registrati possano accedere a queste azioni

  def show
    @challenge_proposal = ChallengeProposal.find(params[:id])
    @test_cases = @challenge_proposal.test_cases
  end

  def new
    @challenge_proposal = ChallengeProposal.new
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
        redirect_to admin_path(current_user)
      else
        flash[:alert]="An error occurred while rejecting the proposal, retry."
        redirect_to admin_path(current_user)
      end
    else
      flash[:alert]="Rejection motivation cannot be null"
      redirect_to admin_path(current_user)
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
end
