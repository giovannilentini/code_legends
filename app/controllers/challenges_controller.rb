class ChallengesController < ApplicationController
  def new
    @challenge = Challenge.new
    @challenge.test_cases.build
  end

  def create
    @challenge = Challenge.new(challenge_params)
    if @challenge.save
      redirect_to @challenge, notice: 'Sfida creata con successo!'
    else
      render :new
    end
  end

  private

  def challenge_params
    params.require(:challenge).permit(:description, test_cases_attributes: [:input_example, :expected_output])
  end
end
