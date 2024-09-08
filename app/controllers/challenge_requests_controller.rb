class ChallengeRequestsController < ApplicationController
  before_action :authenticate_user!, except: [:new]
  before_action :set_challenge_request, only: [:accept, :reject]
  load_and_authorize_resource except: [:create] # Gestisci manualmente l'autorizzazione per create

  def index
    @received_challenge_requests = current_user.received_challenge_requests
    @sent_challenge_requests = current_user.sent_challenge_requests
  end

  def create
    @challenge_request = ChallengeRequest.new(
      user_id: current_user.id,
      friend_id: params[:friend_id],
      language: params[:language]
    )

    if @challenge_request.save
      redirect_to root_path, notice: 'Richiesta di sfida inviata con successo!'
    else
      render :new, alert: "Si è verificato un errore nell'invio della richiesta."
    end
  end

  def accept
    challenge = ChallengeRequest.find(params[:id])

    if challenge.update(status: 'ongoing')
      match = Match.create(
        player_1_id: challenge.user_id,
        player_2_id: challenge.friend_id,
        language: challenge.language,
        status: 'ongoing'
      )

      # Trova l'oggetto User corrispondente al friend_id
      friend = User.find(challenge.friend_id)

      # Broadcasting della notifica al creatore della sfida
      ChallengeNotificationChannel.broadcast_to(
        User.find(challenge.user_id), # L'utente che ha inviato la richiesta
        {
          message: "#{friend.username} ha accettato la tua sfida!",
          match_id: match.id
        }
      )

      challenge.destroy
      redirect_to match_path(match.id)
    else
      flash[:alert] = "Errore nell'accettare la sfida."
      redirect_back(fallback_location: root_path)
    end
  end


  def reject
    challenge = ChallengeRequest.find(params[:id])
    if challenge.destroy
      flash[:notice] = "Richiesta di sfida rifiutata con successo."
    else
      flash[:alert] = "Si è verificato un errore nel rifiuto della richiesta."
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def challenge_params
    params.require(:challenge_request).permit(:sender_id, :receiver_id, :language)
  end
end
