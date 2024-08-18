class MatchmakingChannel < ApplicationCable::Channel
  def subscribed
    stream_from "matchmaking_#{params[:language]}"
    MatchmakingQueue.add(current_user, params[:language])
  end

  def unsubscribed
    MatchmakingQueue.remove(current_user)
  end
end

