class RoomsController < ApplicationController
    def show
      @room = Room.find_by(uuid: params[:id])
      # Assicurati di gestire il caso in cui la stanza non viene trovata
      unless @room
        flash[:alert] = "Room not found"
        redirect_to root_path
      end
    end
  end
  