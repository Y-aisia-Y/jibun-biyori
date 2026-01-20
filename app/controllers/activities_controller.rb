class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record
  before_action :set_activity, only: %i[show edit update destroy]

  def index
    @activities = @record.activities.order(start_time: :asc).decorate
  end
  
  def show
  end

  def new
    @activity = @record.activities.build
    
    # hourパラメータがある場合は開始時刻を設定
    if params[:hour].present?
      date = params[:date] || @record.recorded_date
      @activity.start_time = Time.zone.parse("#{date} #{params[:hour]}:00")
      @activity.end_time = @activity.start_time + 1.hour
    end
  end

  def create
    @activity = @record.activities.build(activity_params)
    
    if @activity.save
      redirect_to records_path(date: @record.recorded_date), notice: '活動を記録しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # 編集画面を表示
  end

  def update
    if @activity.update(activity_params)
      redirect_to records_path(date: @record.recorded_date), notice: '活動を更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @activity.destroy!
    redirect_to records_path(date: @record.recorded_date), notice: '活動を削除しました'
  rescue ActiveRecord::RecordNotDestroyed => e
    redirect_to edit_record_activity_path(@record, @activity), alert: '削除に失敗しました'
  end

  private

  def set_record
    @record = current_user.records.find(params[:record_id])
  end

  def set_activity
    @activity = @record.activities.find(params[:id])
  end

  def activity_params
    permitted_params = params.require(:activity).permit(
      :content,
      :start_date, :start_hour, :start_minute,
      :end_date, :end_hour, :end_minute
    )

    # 日時の組み立て
    if permitted_params[:start_date].present?
      permitted_params[:start_time] = Time.zone.parse(
        "#{permitted_params[:start_date]} #{permitted_params[:start_hour]}:#{permitted_params[:start_minute]}"
      )
    end
  
    if permitted_params[:end_date].present?
      permitted_params[:end_time] = Time.zone.parse(
        "#{permitted_params[:end_date]} #{permitted_params[:end_hour]}:#{permitted_params[:end_minute]}"
      )
    end
  
    # 必要なパラメータのみを返す
    permitted_params.slice(:content, :start_time, :end_time)
  end
end
