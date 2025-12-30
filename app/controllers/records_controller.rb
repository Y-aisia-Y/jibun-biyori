class RecordsController < ApplicationController
  include CurrentTimeSettable

  before_action :set_record, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[show edit update destroy]
  before_action :set_custom_record_items, only: %i[new edit]
  before_action :build_record_values, only: %i[new edit]

  def index
    @date = params[:date]&.to_date || Date.current

    # 指定した日付の記録を取得(入力フォーム用)
    @record = current_user.records.includes(:record_values, :activities).find_or_initialize_by(recorded_date: @date)

    # 指定した日付の記録だけを取得(表示用)
    @records = @record.persisted? ? [@record] : []
  
    # 表示項目のみを取得
    @record_items = current_user.record_items.where(is_default_visible: true).order(:display_order)
  
    @activities = @record.persisted? ? @record.activities : []

    @current_hour = Time.current.hour
    @current_minute = Time.current.min

    set_current_time
  end

  def show
    @activities = @record.activities
  end

  def new
    @record = current_user.records.build(recorded_date: Date.current)

  end

  def edit
  end

  def create
    @record = current_user.records.build(record_params)

    if @record.save
      redirect_to records_path, success: '記録を作成しました'
    else
      set_custom_record_items
      build_record_values
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @record.update(record_params)
      redirect_to record_path(@record), success: '記録を更新しました'
    else
      set_custom_record_items
      build_record_values
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @record.destroy!
    redirect_to records_url, notice: "記録を削除しました。", status: :see_other
  end

  def create_with_activity
    date = params[:date]&.to_date || Date.current

    record = current_user.records.find_or_create_by!(
      recorded_date: date
    )

    redirect_to new_record_activity_path(
      record,
      date: date,
      hour: params[:hour]
    )
  end

  private

  def set_record
    @record = current_user.records.find(params[:id])
  end

  def authorize_user!
    return if @record.user_id == current_user.id

    redirect_to records_path, alert: "アクセス権限がありません。"
  end

  def set_custom_record_items
    @record_items = current_user.record_items.where(category: :custom, is_default_visible: true).order(:display_order)
  end

  def build_record_values
    @record_items.each do |item|
      @record.record_values.find_or_initialize_by(record_item: item)
    end
  end

  def record_params
    params.require(:record).permit(
      :recorded_date,
      :diary_memo,
      record_values_attributes: [
        :id,
        :record_item_id,
        :value,
        :sleep_time,
        :wake_time,
        :_destroy
      ]
    )
  end
end
