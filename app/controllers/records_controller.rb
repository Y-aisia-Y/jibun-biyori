class RecordsController < ApplicationController
  include CurrentTimeSettable

  before_action :authenticate_user!
  before_action :set_record, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[show edit update destroy]
  before_action :set_record_for_date, only: %i[new_health new_diary]

  def index
    @date = params[:date]&.to_date || Date.current

    # 指定した日付の記録を取得(入力フォーム用)
    @record = current_user.records
                          .includes(:record_values, :activities)
                          .find_or_initialize_by(recorded_date: @date)

    # 指定した日付の記録だけを取得(表示用)
    @records = @record.persisted? ? [@record] : []
  
    set_all_visible_items
    @activities = @record.persisted? ? @record.activities : []
    set_current_time
  end

  def show
    @record = current_user.records
      .includes(:record_values, :activities)
      .find(params[:id])
  end

  def new
    @record = current_user.records.build
    set_all_visible_items
  end

  def edit
    set_all_visible_items
  end

  def create  
    @record = Record.new(record_params)
    @record.user = current_user
  
    if @record.save
      redirect_to_record_date(@record, '記録を作成しました')
    else
      set_record_items
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @record.update(record_params)
      redirect_to_record_date(@record, '記録を更新しました')
    else
      set_record_items
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    recorded_date = @record.recorded_date
    
    if @record.destroy
      redirect_to records_url(date: recorded_date), notice: "記録を削除しました。", status: :see_other
    else
      redirect_to records_url(date: recorded_date), alert: "記録の削除に失敗しました。", status: :see_other
    end
  end

  def create_with_activity
    date = params[:date]&.to_date || Date.current
    record = current_user.records.find_or_create_by!(recorded_date: date)

    redirect_to new_record_activity_path(record, date: date, hour: params[:hour])
  end

  def new_health
    @date = params[:date]&.to_date || Date.current
    set_record_for_date
    @items = current_user.record_items.system_items.visible.ordered
    prepare_record_values(@items)
    render :health
  end

  def new_diary
    @date = params[:date]&.to_date || Date.current
    set_record_for_date
    @items = current_user.record_items.user_items.visible.ordered
    prepare_record_values(@items)
    render :diary
  end

  private

  def set_record
    @record = current_user.records.find(params[:id])
  end

  def set_record_for_date
    @record = current_user.records.find_or_initialize_by(recorded_date: @date)
    @record.recorded_date = @date
  end

  def prepare_record_values(items)
    items.each do |item|
      unless @record.record_values.exists?(record_item_id: item.id)
        @record.record_values.build(record_item: item)
      end
    end
  end

  def authorize_user!
    return if @record.user_id == current_user.id

    redirect_to records_path, alert: "アクセス権限がありません。"
  end

  def set_record_items
    @record_items = current_user.record_items.system_items.visible.ordered
  end

  def set_all_visible_items
    @record_items = current_user.record_items.where(is_default_visible: true).order(:display_order)
  end

  def redirect_to_record_date(record, message)
    redirect_to records_path(date: record.recorded_date), success: message
  end

  def record_params
    params.require(:record).permit(
      :recorded_date,
      :diary_memo,
      record_values_attributes: [
        :id,
        :record_item_id,
        :value,
        :_destroy,
        :sleep_hour,
        :sleep_minute,
        :wake_hour,
        :wake_minute
      ]
    )
  end
end
