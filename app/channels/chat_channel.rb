class ChatChannel < ApplicationCable::Channel
  def subscribed
    match = Match.find(params[:match_id])
    stream_for match
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_message(data)
    message = ChatMessage.create!(
      match_id: data['match_id'],
      user_id: data['user_id'],
      content: data['content']
    )
    ChatChannel.broadcast_to(message.match, render_message(message))
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: 'chat_messages/message', locals: { message: message })
  end
end
