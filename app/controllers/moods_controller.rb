class MoodsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record
  before_action :set_mood, only: %i[edit update destroy]

  def new
    if @record.mood.present?
      redirect_to edit_record_mood_path(@record, @record.mood) and return
    end
    @mood = @record.build_mood
  end

  def create
    @mood = @record.build_mood(mood_params)

    if @mood.save
      redirect_to record_path(@record), success: '気分を記録しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @mood.update(mood_params)
      redirect_to record_path(@record)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @mood.destroy
    redirect_to record_path(@record), danger: '気分を削除しました。', status: :see_other
  end

  private

  def set_record
    @record = current_user.records.find(params[:record_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to records_path, warning: '指定された記録が見つかりません。'
  end
  
  def set_mood
    @mood = @record.mood || raise(ActiveRecord::RecordNotFound)
  rescue ActiveRecord::RecordNotFound
    redirect_to record_path(@record), warning: '指定された気分記録が見つかりません。'
  end

  def mood_params
    params.require(:mood).permit(:rating, :comment)
  end
end
