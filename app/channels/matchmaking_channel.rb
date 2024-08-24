class MatchmakingChannel < ApplicationCable::Channel
  def subscribed
    stream_from "matchmaking_channel"
  end

  def unsubscribed
    MatchmakingQueueService.remove(Player.find_or_create_by(name: session[:player_name]), params[:language])
    p MatchmakingQueueService.queue
  end
end

