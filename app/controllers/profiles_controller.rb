class ProfilesController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @user = current_user
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update(profile_params)
      redirect_to profile_path, success: 'プロフィールを更新しました'
    else
      flash.now[:danger] = 'プロフィールの更新に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end
  
  private
  
  def profile_params
    params.require(:user).permit(:email, :nickname, :first_name, :last_name, :avatar, :avatar_cache)
  end
end
