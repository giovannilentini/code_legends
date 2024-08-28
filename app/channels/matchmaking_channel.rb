class MatchmakingChannel < ApplicationCable::Channel
  def subscribed
    stream_from "matchmaking_#{current_user.id}"
  end

  def unsubscribed
    MatchmakingQueueService.remove_from_queue(current_user)
  end
end

