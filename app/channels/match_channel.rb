class MatchChannel < ApplicationCable::Channel
  def subscribed
     stream_from "match_#{params[:match_id]}"
  end

end
