class MatchmakingChannel < ApplicationCable::Channel
  def subscribed
    if params[:language].present?
      stream_from "matchmaking_#{params[:language]}"
    else
      reject
    end
  end

  def unsubscribed
    MatchmakingQueueService.remove(current_user, params[:language])
    p MatchmakingQueueService.queue
  end
end

