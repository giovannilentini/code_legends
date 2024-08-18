class ChallengesController < ApplicationController
  before_action :set_player, only: [:create, :check_challenge, :waiting]

  def show
    @challenge = Challenge.find(params[:id])
  end

  def create
    @player = Player.find_or_create_by(name: session[:player_name])
    session[:player_id] = @player.id

    opponent = Player.find_by(waiting: true)
    
    if opponent.nil?
      @player.update(waiting: true)
      redirect_to waiting_path
    else
      challenge = Challenge.create(player_1: @player, player_2: opponent, status: 'pending')

      if challenge.persisted?
        room = Room.create(challenge: challenge, uuid: SecureRandom.uuid)

        if room.persisted?
          @player.update(waiting: false)
          opponent.update(waiting: false)
          redirect_to challenge_path(challenge.id)
        else
          flash[:error] = "Impossibile creare la stanza di sfida."
          redirect_to play_now_path
        end
      else
        flash[:error] = "Impossibile creare la sfida."
        redirect_to play_now_path
      end
    end
  end

  def check_challenge
    @player = Player.find(session[:player_id])
  
    if @player.nil?
      render json: { error: 'Player not found' }, status: :unprocessable_entity
      return
    end
  
    challenge = Challenge.find_by("player_1_id = ? OR player_2_id = ?", @player.id, @player.id)
  
    if challenge
      room = Room.find_by(challenge: challenge)
      
      if room
        render json: { challenge_url: challenge_path(room.challenge), room_uuid: room.uuid }
      else
        render json: { error: 'Room not found' }, status: :not_found
      end
    else
      render json: { error: 'Challenge not found' }, status: :not_found
    end
  end  

  def waiting
    @player = Player.find(session[:player_id])
  end

  private

  def set_player
    @player = Player.find_or_create_by(name: session[:player_name])
    session[:player_id] ||= @player.id
  end
end
