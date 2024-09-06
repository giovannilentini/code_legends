class SettingsController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(user_params)
      redirect_to user_profile_path(@user), notice: 'Profilo aggiornato con successo.'
    else
      flash.now[:alert] = 'Errore nell\'aggiornamento del profilo.'
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile_image)
  end
end
