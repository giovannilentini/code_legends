class MatchmakingChannel < ApplicationCable::Channel
  def subscribed
    stream_from "matchmaking_#{params[:language]}"
    MatchmakingQueueService.add(current_user, params[:language])
  end

  def unsubscribed
    MatchmakingQueueService.remove(current_user)
  end
end

