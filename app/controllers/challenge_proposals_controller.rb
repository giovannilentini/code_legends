class ChallengeProposalsController < ApplicationController

  def show
    @challenge_proposal = ChallengeProposal.find(params[:id])
    @test_cases = @challenge_proposal.test_cases.to_json
    p "TEST_CASES"
    p @test_cases
  end

  def new
    @challenge_proposal = ChallengeProposal.new
  end

  def create
    @challenge_proposal = ChallengeProposal.new(challenge_proposal_params)
    @challenge_proposal.user = current_user
    if @challenge_proposal.save
      redirect_to challenge_proposal_path(@challenge_proposal)
    else
      flash[:alert]="An error occurred while creating the challenge proposal, retry."
      Rails.logger.info(@challenge_proposal.errors.inspect)
      redirect_to new_challenge_proposal_path
    end



  end



  private
  def challenge_proposal_params
    params.require(:challenge_proposal).permit(:title, :description, :test_cases, :language)
  end
end
