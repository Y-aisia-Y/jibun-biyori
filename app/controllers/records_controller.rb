class RecordsController < ApplicationController
  include CurrentTimeSettable

  before_action :authenticate_user!
  before_action :set_date, only: %i[dashboard new_health new_diary create_with_activity]
  before_action :set_record, only: %i[show edit update destroy edit_diary update_diary]
  before_action :authorize_user!, only: %i[show edit update destroy edit_diary update_diary]
  before_action :set_record_for_date, only: %i[new_health new_diary]

  def index
    @records = current_user.records
                           .where.not(diary_memo: [nil, ""])
                           .order(recorded_date: :desc)

    if params[:q].present?
      @records = @records.where("diary_memo LIKE ?", "%#{params[:q]}%")
    end
  end

  def dashboard
    @record = current_user.records
                          .includes(:record_values, :activities)
                          .find_or_initialize_by(recorded_date: @date)

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

  def edit_diary
  end

  def create
    redirect_to_dashboard = params[:record].delete(:redirect_to_dashboard) == "true"
    record_params = processed_record_params
  
  # 同じ日付のレコードを探す
    @record = current_user.records.find_or_initialize_by(recorded_date: record_params[:recorded_date])
  
  # 既存のレコードの場合は recorded_date 以外を更新
    if @record.persisted?
      params_without_date = record_params.except(:recorded_date)
      @record.assign_attributes(params_without_date)
    else
      @record.assign_attributes(record_params)
    end

  # 日記として保存する場合はコンテキストを指定
    if redirect_to_dashboard
      save_result = @record.save
    else
      save_result = @record.save(context: :diary)
    end

    if save_result
      if redirect_to_dashboard
        redirect_to dashboard_path(date: @record.recorded_date),
                    success: "体調を記録しました"
      else
        redirect_to records_path,
                    success: "日記を作成しました"
      end
    else
      if redirect_to_dashboard
        set_all_visible_items
        flash.now[:danger] = "保存に失敗しました"
        render :new, status: :unprocessable_entity
      else
        @items = current_user.record_items.user_items.visible.ordered
        prepare_record_values(@items)
        @record.recorded_date ||= Date.current
        flash.now[:danger] = "保存に失敗しました"
        render :diary, status: :unprocessable_entity
      end
    end
  end

  def update
    @record.assign_attributes(processed_record_params)

    if params[:record][:redirect_to_dashboard] == "true"
      update_result = @record.save
    else
      update_result = @record.save(context: :diary)
    end

    if update_result
      if params[:record][:redirect_to_dashboard] == "true"
        redirect_to dashboard_path(date: @record.recorded_date), success: "体調を更新しました"
      else
        redirect_to records_path, success: "日記を更新しました"
      end
    else
      set_all_visible_items
      flash.now[:danger] = "更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def update_diary
    @record.assign_attributes(processed_record_params)
    
    if @record.save(context: :diary)
      redirect_to records_path, success: "日記を更新しました"
    else
      flash.now[:danger] = "更新に失敗しました"
      render :edit_diary, status: :unprocessable_entity
    end
  end

  def destroy
    recorded_date = @record.recorded_date

    if @record.destroy
      redirect_to records_url(date: recorded_date),
                  danger: "記録を削除しました。",
                  status: :see_other
    else
      redirect_to records_url(date: recorded_date),
                  warning: "記録の削除に失敗しました。",
                  status: :see_other
    end
  end

  def create_with_activity
    record = current_user.records.find_or_create_by!(recorded_date: @date)
    redirect_to new_record_activity_path(record, date: @date, hour: params[:hour])
  end

  def new_health
    @items = current_user.record_items.system_items.visible.ordered
    prepare_record_values(@items)
    render :health
  end

  def new_diary
    @items = current_user.record_items.user_items.visible.ordered
    @date = params[:date]&.to_date || Date.current
    @record = current_user.records.find_or_initialize_by(recorded_date: @date)
    prepare_record_values(@items)
  
    render :diary
  end

  private

  def set_date
    @date = params[:date]&.to_date || Date.current
  end

  def set_record
    @record = current_user.records
                          .includes(:record_values, :activities)
                          .find_by(id: params[:id])

    unless @record
      redirect_to records_path, warning: "記録が見つかりません"
      return
    end
  end

  def set_record_for_date
    @record = current_user.records.find_or_initialize_by(recorded_date: @date)
    @record.recorded_date = @date
  end

  def authorize_user!
    return if @record && @record.user_id == current_user.id

    respond_to do |format|
      format.html { redirect_to records_path, warning: "権限がありません" }
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
      unless @record.record_values.any? { |rv| rv.record_item_id == item.id }
        @record.record_values.build(record_item: item)
      end
    end
  end

  def processed_record_params
    params_hash = record_params.to_h.deep_dup

    if params_hash["record_values_attributes"]
      params_hash["record_values_attributes"].each_value do |attributes|
        next unless attributes["sleep_hour"].present?

        record_item =
          if attributes["id"].present?
            RecordValue.find_by(id: attributes["id"])&.record_item
          elsif attributes["record_item_id"].present?
            RecordItem.find_by(id: attributes["record_item_id"])
          end

        next unless record_item&.input_type == "time_range"

        sleep_time = Time.zone.parse(
          "#{attributes["sleep_hour"]}:#{attributes["sleep_minute"]}"
        )
        wake_time = Time.zone.parse(
          "#{attributes["wake_hour"]}:#{attributes["wake_minute"]}"
        )

        wake_time += 1.day if wake_time < sleep_time

        attributes["value"] =
          "#{sleep_time.strftime('%H:%M')}-#{wake_time.strftime('%H:%M')}"
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

      (activity.start_time.hour..activity.end_time.hour).each do |hour|
        result[hour] ||= []
        result[hour] << ActivityPresenter.new(activity, hour)
      end
    end

    result
  end
end
