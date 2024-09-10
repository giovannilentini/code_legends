class ChatMessagesController < ApplicationController

  def create
    authorize! :chat, :all
    @match = Match.find(params[:match_id])
    @chat_message = @match.chat_messages.new(chat_message_params)
    @chat_message.user = current_user

    if @chat_message.save
      ChatChannel.broadcast_to @match, render_to_string(partial: 'chat_messages/chat_message', locals: { chat_message: @chat_message })
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def chat_message_params
    params.require(:chat_message).permit(:content)
  end
end
