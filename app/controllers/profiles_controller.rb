class ProfilesController < ApplicationController
  before_action :authenticate_user!  # Deviseのログイン認証
  
  def show
    @user = current_user
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update(profile_params)
      redirect_to profile_path, success: t('defaults.flash_message.updated', item: User.model_name.human)
    else
      flash.now[:danger] = t('defaults.flash_message.not_updated', item: User.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end
  
  private
  
  def profile_params
    params.require(:user).permit(:email, :nickname, :first_name, :last_name, :avatar, :avatar_cache)
  end
end
