class ChallengeRequestsController < ApplicationController
  def index
    @received_challenge_requests = current_user.received_challenge_requests
    @sent_challenge_requests = current_user.sent_challenge_requests
  end

  def create
    @challenge_request = ChallengeRequest.new(user_id: current_user.id, friend_id: params[:friend_id])

    if @challenge_request.save
      # Logica per inviare una notifica o simile
      redirect_to challenge_requests_path, notice: 'Richiesta di sfida inviata.'  # Usa challenge_requests_path qui
    else
      redirect_to challenge_requests_path, alert: 'Errore nell\'invio della richiesta di sfida.'
    end
  end

  def accept
    @challenge_request = ChallengeRequest.find(params[:id])

    if Time.current - @challenge_request.created_at < 90.seconds
      # Logica per accettare la sfida
      redirect_to match_path(@challenge_request.id)
    else
      redirect_to challenge_requests_path, alert: 'La sfida non è più disponibile.'
    end
  end

  def reject
    @challenge_request = ChallengeRequest.find(params[:id])
    @challenge_request.destroy
    redirect_to challenge_requests_path, notice: 'Richiesta di sfida rifiutata.'
  end
end
