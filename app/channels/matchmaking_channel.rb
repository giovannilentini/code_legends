class MatchmakingChannel < ApplicationCable::Channel
  def subscribed
    if params[:language].present?
      stream_from "matchmaking_#{params[:language]}"
    else
      reject
    end
  end

  def unsubscribed
    p "UNSUBSCRIBEEEED"
    MatchmakingQueueService.remove(current_user, params[:language])
    MatchmakingQueueService.print_queue
  end
end

