class SettingsController < ApplicationController
  before_action :authenticate_user!
  

  def edit
    if current_user.guest?
      flash[:alert] = "You must be logged in to edit your profile."
      redirect_to root_path
    else
      @user = current_user
    end
  end

  def update
    if current_user.guest?
      flash[:alert] = "You must be logged in to edit your profile."
      redirect_to root_path
    else
      @user = current_user
      if @user.update(user_params)
        redirect_to user_profile_path(@user), notice: 'Profilo aggiornato con successo.'
      else
        flash.now[:alert] = 'Errore nell\'aggiornamento del profilo.'
        render :edit
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile_image)
  end

def authenticate_user!
  unless session[:user_id] # Verifica se l'ID dell'utente è presente nella sessione
     redirect_to root_path ,alert: "You must be logged in to see your profile."
  end
end
end

