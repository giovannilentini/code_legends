class ChallengesController < ApplicationController
  before_action :set_challenge, only: [:update_status]

  def new
    @challenge = Challenge.new
    @challenge.test_cases.build
  end

  def create

    ActiveRecord::Base.transaction do
    @challenge = current_user.challenges.new(challenge_params)

    # Filter out invalid test cases
    valid_test_case_params = test_case_params.reject do |_, params|
      params[:input_example].blank? || params[:expected_output].blank?
    end

    valid_test_case_params.each do |index, test_case_params|
        input_example = test_case_params[:input_example]
        expected_output = test_case_params[:expected_output]
        input_type = test_case_params[:input_type]
        output_type = test_case_params[:output_type]
        TestCase.create(input_example: input_example, expected_output: expected_output, input_type: input_type, output_type: output_type, challenge: @challenge)
      end
    end
    if @challenge.save
      #redirect_to root_path, notice: 'Sfida creata con successo.'
    else
      render :new
    end
  end

  def update_status
    @challenge = Challenge.find(params[:id])
    puts "Trovato challenge: #{@challenge.inspect}"

    @challenge.status = params[:status]
    puts "Nuovo stato: #{@challenge.status}"

    if @challenge.status.to_i == 0
      @challenge.rejection_reason = params[:rejection_reason]
      puts "Motivo del rifiuto: #{@challenge.rejection_reason}"
    else
      @challenge.rejection_reason = nil
    end

    if @challenge.save
      puts "Salvato con successo"
      redirect_to admin_profile_path, notice: 'Stato aggiornato con successo.'
    else
      puts "Errore nel salvataggio: #{@challenge.errors.full_messages}"
      redirect_to admin_profile_path, alert: 'Errore nell\'aggiornamento dello stato.'
    end
  end

  private

  def set_challenge
    @challenge = Challenge.find(params[:id])
  end

  def challenge_params
    params.require(:challenge).permit(:description, test_cases_attributes: [:input_example, :expected_output, :input_type, :output_type])
  end

  def test_case_params
    params.require(:challenge).permit(test_cases_attributes: [:input_example, :expected_output, :input_type, :output_type])
  end
end
