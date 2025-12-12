class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record
  before_action :set_activity, only: %i[show edit update destroy]

  def index
    @activities = @record.activities.order(start_time: :asc)
  end
  
  def show
  end

  def new
    @activity = @record.activities.build
  end

  def create
    @activity = @record.activities.build(activity_params)

    if @activity.save
      redirect_to record_path(@record), notice: '活動を登録しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @activity.update(activity_params)
      redirect_to record_path(@record), notice: '活動を更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @activity.destroy
    redirect_to record_path(@record), notice: '活動を削除しました。', status: :see_other
  end

  private

  def set_record
    @record = current_user.records.find(params[:record_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to records_path, alert: '指定された記録が見つかりません。'
  end

  def set_activity
    @activity = @record.activities.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to record_path(@record), alert: '指定された活動が見つかりません。'
  end

  def activity_params
    params.require(:activity).permit(:start_time, :end_time, :content)
  end
end
