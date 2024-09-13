class ChatMessagesController < ApplicationController

  def create
    p chat_message_params

    @match = Match.find(params[:match_id])
    @chat_message = @match.chat_messages.new(chat_message_params)
    @chat_message.user = current_user
    authorize! :create, @chat_message

    if @chat_message.content == ""
      flash[:alert] = "Message must be not empty!"
    elsif @chat_message.content.length > 500
      flash[:alert] = "Message must be less than 500 characters."
    else
      if @chat_message.save
        ChatChannel.broadcast_to @match, render_to_string(partial: 'chat_messages/chat_message', locals: { chat_message: @chat_message })
        head :ok
      else
        head :unprocessable_entity
      end
    end
  end

  private

  def chat_message_params
    params.require(:chat_message).permit(:user_id, :content)
  end
end
