class RecordsController < ApplicationController
  include CurrentTimeSettable

  before_action :authenticate_user!
  before_action :set_record, only: %i[show edit update destroy edit_diary update_diary]
  before_action :authorize_user!, only: %i[show edit update destroy edit_diary update_diary]
  before_action :set_record_for_date, only: %i[new_health new_diary]

  def index
    @records = current_user.records
                           .where.not(diary_memo: [nil, ""])
  
    if params[:q].present?
      @records = @records.where("diary_memo LIKE ?", "%#{params[:q]}%")
    end

    @records = @records.order(recorded_date: :desc)
  end

  def edit_diary
    @record = current_user.records.find(params[:id])
  end

  def update_diary
    if @record.update(processed_record_params)
      redirect_to records_path, notice: "日記を更新しました"
    else
      set_all_visible_items
      render :edit_diary, status: :unprocessable_entity
    end
  end

  def dashboard
    @date = params[:date]&.to_date || Date.current

    # 指定した日付の記録を取得(入力フォーム用)
    @record = current_user.records
                          .includes(:record_values, :activities)
                          .find_or_initialize_by(recorded_date: @date)

    # 指定した日付の記録だけを取得(表示用)
    @records = @record.persisted? ? [@record] : []

    set_all_visible_items
  
    if @record.persisted?
      @activities = @record.activities
      @activities_by_hour = expand_activities_by_hour(@activities)
    else
      @activities = []
      @activities_by_hour = {}
    end
  
    set_current_time
  end

  def show
    @record = current_user.records.includes(:record_values, :activities).find(params[:id])
    @date = @record.recorded_date
    @current_hour = Time.current.hour
    @current_minute = Time.current.min

    @activities_by_hour = expand_activities_by_hour(@record.activities)
  end

  def new
    @record = current_user.records.build
    set_all_visible_items
  end

  def edit
    set_all_visible_items
  end

  def create
    @record = Record.new(processed_record_params)
    @record.user = current_user

    if @record.save
      redirect_to records_path, notice: "日記を作成しました"
    else
      set_all_visible_items
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @record.update(processed_record_params)
      redirect_to records_path, notice: "日記を更新しました"
    else
      set_all_visible_items
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

  def diary_params
    params.require(:record).permit(:diary_memo)
  end

  def set_record
    @record = current_user.records.find(params[:id])
  end

  def set_record_for_date
    @record = current_user.records.find_or_initialize_by(recorded_date: @date)
    @record.recorded_date = @date
  end

  def authorize_user!
    return if @record.user == current_user

    respond_to do |format|
      format.html { redirect_to records_path, alert: "権限がありません" }
      format.turbo_stream { head :forbidden }
    end
  end

  def set_all_visible_items
    @record_items = current_user.record_items
                                .where(is_default_visible: true)
                                .order(:display_order)
  end

  def prepare_record_values(items)
    items.each do |item|
      # すでに record_value が存在しない場合のみ build
      unless @record.record_values.any? { |rv| rv.record_item_id == item.id }
        @record.record_values.build(record_item: item)
      end
    end
  end

  def redirect_to_record_date(record, message)
    redirect_to dashboard_path(date: record.recorded_date), success: message
  end

  def processed_record_params
    params_hash = record_params.to_h.deep_dup
    
    # record_values_attributes を処理
    if params_hash['record_values_attributes']
      params_hash['record_values_attributes'].each do |key, attributes|
        # sleep_hour が存在しない場合はスキップ
        next unless attributes['sleep_hour'].present?
        
        # record_item を取得
        record_item = if attributes['id'].present?
          # 既存のレコードの場合
          record_value = RecordValue.find_by(id: attributes['id'])
          record_value&.record_item
        elsif attributes['record_item_id'].present?
          # 新規レコードの場合
          RecordItem.find_by(id: attributes['record_item_id'])
        end
        
        # time_range の場合のみ処理
        if record_item&.input_type == 'time_range'
          sleep_time = Time.zone.parse("#{attributes['sleep_hour']}:#{attributes['sleep_minute']}")
          wake_time = Time.zone.parse("#{attributes['wake_hour']}:#{attributes['wake_minute']}")
          
          # 翌日判定
          wake_time += 1.day if wake_time < sleep_time
          
          # value を設定
          params_hash['record_values_attributes'][key]['value'] = 
            "#{sleep_time.strftime('%H:%M')}-#{wake_time.strftime('%H:%M')}"
        end
      end
    end
    
    params_hash
  end

  def record_params
    params.require(:record).permit(
      :recorded_date,
      :diary_memo,
      record_values_attributes: [
        :id,
        :record_item_id,
        :_destroy,
        :value,
        :sleep_hour,
        :sleep_minute,
        :wake_hour,
        :wake_minute
      ]
    )
  end

  def expand_activities_by_hour(activities)
    result = {}
  
    activities.each do |activity|
      next unless activity.start_time && activity.end_time
    
      start_hour = activity.start_time.hour
      end_hour = activity.end_time.hour
    
      (start_hour..end_hour).each do |hour|
        result[hour] ||= []
        result[hour] << ActivityPresenter.new(activity, hour)
      end
    end
  
    result
  end
end
