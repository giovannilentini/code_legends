class SubmissionChannel < ApplicationCable::Channel
  def subscribed
    stream_from "submission_#{params[:match_id]}_#{params[:user_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
