class MatchesController < ApplicationController
  before_action :set_user, only: [:create, :check_challenge]
  before_action :set_challenge, only: [:show]

  def show
    @selected_language = @challenge.language
  end

  def create
    @user = Player.find_or_create_by(name: session[:player_name])
    session[:player_id] = @user.id

    opponent = Player.find_by(waiting: true)
    
    if opponent.nil?
      @user.update(waiting: true)
      redirect_to waiting_path
    else
      challenge = Match.create(player_1: @user, player_2: opponent, status: 'pending')

      if challenge.persisted?
        room = Room.create(challenge: challenge, uuid: SecureRandom.uuid)

        if room.persisted?
          @user.update(waiting: false)
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
    @user = Player.find(session[:player_id])
  
    if @user.nil?
      render json: { error: 'Player not found' }, status: :unprocessable_entity
      return
    end
  
    challenge = Match.find_by("player_1_id = ? OR player_2_id = ?", @player.id, @player.id)
  
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

  def execute_code
    response = JdoodleService.execute_code(params[:code], params[:language])
    unless response.nil?
      if response.code == "200"
        @result = JSON.parse(response.body)["output"]
      else
        @result = JSON.parse(response.body)["error"]
      end
    end
    render json: { output: @result }
  end

  private
  def set_user
    @user = User.find_or_create_by(id: session[:user_id])
  end
  def set_challenge
    @challenge = Match.find_by(id: params[:id])
  end
end
