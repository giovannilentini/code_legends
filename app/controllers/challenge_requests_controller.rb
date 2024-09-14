class ChallengeRequestsController < ApplicationController

  def index
    authorize! :read, ChallengeRequest
    @received_challenge_requests = current_user.received_challenge_requests
    @sent_challenge_requests = current_user.sent_challenge_requests

    head :ok
  end

  def create
    authorize! :create, ChallengeRequest
    @challenge_request = ChallengeRequest.new(
      user_id: current_user.id,
      friend_id: params[:friend_id],
      language: params[:language]
    )

    if @challenge_request.save
      ActionCable.server.broadcast 'notifications_channel', { has_notifications: true }
      redirect_to root_path, notice: 'Succesfully created the challenge request!'
    else
      redirect_to root_path, alert: "An Error Occurred while creating the challenge request!"

    end
  end

  def accept
    challenge = ChallengeRequest.find(params[:id])
    authorize! :accept,challenge

    if challenge.update(status: 'ongoing')
      match_challenge = Challenge.find_by(id: Challenge.where(language: challenge.language).pluck(:id).sample)
      match = Match.create(
        player_1_id: challenge.user_id,
        player_2_id: challenge.friend_id,
        language: challenge.language,
        challenge_id: match_challenge.id,
        status: 'ongoing'
      )

      # Trova l'oggetto User corrispondente al friend_id
      friend = User.find(challenge.friend_id)

      # Broadcasting della notifica al creatore della sfida
      ChallengeNotificationChannel.broadcast_to(
        User.find(challenge.user_id), # L'utente che ha inviato la richiesta
        {
          message: "#{friend.username} accepted the challenge request!",
          match_id: match.id
        }
      )

      challenge.destroy
      redirect_to match_path(match.id)
    else
      flash[:alert] = "Error occurred while accepting challenge."
      redirect_back(fallback_location: root_path)
    end
  end


  def reject
    challenge = ChallengeRequest.find(params[:id])
    authorize! :accept,challenge
    if challenge.destroy
      flash[:notice] = "Challenge request was rejected."
    else
      flash[:alert] = "An error occured while rejecting the challenge request."
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def challenge_params
    params.require(:challenge_request).permit(:sender_id, :receiver_id, :language)
  end
end
