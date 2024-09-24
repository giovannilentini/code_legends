class MatchmakingChannel < ApplicationCable::Channel
  def subscribed
    stream_from "matchmaking_#{current_user.id}"
  end

end

