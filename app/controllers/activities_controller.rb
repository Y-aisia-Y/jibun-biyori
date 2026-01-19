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
    @date = params[:date]&.to_date || @record.recorded_date
    @hour = params[:hour].to_i

    @activity = @record.activities.new(
      start_time: @date.to_time.change(hour: @hour)
    )
  end

  def create
    attrs = activity_params

    start_time = Time.zone.parse("#{attrs[:start_date]} #{attrs[:start_hour]}:#{attrs[:start_minute]}")
    end_time   = Time.zone.parse("#{attrs[:end_date]} #{attrs[:end_hour]}:#{attrs[:end_minute]}")

    @activity = @record.activities.build(
      content: attrs[:content],
      start_time: start_time,
      end_time: end_time
    )

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
    params.require(:activity).permit(
      :content,
      :start_date,
      :start_hour,
      :start_minute,
      :end_date,
      :end_hour,
      :end_minute
    )
  end
end
