class MatchmakingChannel < ApplicationCable::Channel
  def subscribed
    p "USER DISCONNECTED"
    p current_user
    stream_from "matchmaking_#{params[:language]}"
    MatchmakingQueueService.add(current_user, params[:language])
  end

  def unsubscribed
    p "USER DISCONNECTED"
    p current_user
    MatchmakingQueueService.remove(current_user)
  end
end

