# frozen_string_literal: true

class RecordsController < ApplicationController
  include CurrentTimeSettable

  before_action :authenticate_user!
  before_action :set_current_display_date
  before_action :set_date, only: %i[dashboard new_health new_diary create_with_activity]
  before_action :set_record, only: %i[show edit update destroy edit_diary update_diary]
  before_action :authorize_user!, only: %i[show edit update destroy edit_diary update_diary]
  before_action :set_record_for_date, only: %i[new_health new_diary]
  before_action :set_current_time, only: %i[index show]

  def index
    @records = current_user.records
                           .where.not(diary_memo: [nil, ""])
                           .order(recorded_date: :desc)

    return if params[:q].blank?

    @records = @records.where("diary_memo LIKE ?", "%#{params[:q]}%")
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

  def new_health
    @items = current_user.record_items.system_items.visible.ordered
    prepare_record_values(@items)
    render :health
  end

  def new_diary
    date = params[:date] ? Date.parse(params[:date]) : Date.current
    @record = current_user.records.find_or_initialize_by(recorded_date: date)

    build_missing_record_values(@record)

    render :diary
  end

  def edit_diary
    # 既存の日記を編集
  end

  def create
    @record = find_or_build_record
    assign_attributes_to_record

    if save_record
      redirect_after_save
    else
      render_after_failure
    end
  end

  def update
    @record.assign_attributes(processed_record_params)

    from_page = params[:from]

    update_result = if from_page == 'charts' || from_page == 'dashboard'
                      @record.save
                    else
                      @record.save(context: :diary)
                    end

    if update_result
      if from_page == 'charts'
        redirect_to charts_path, success: t('.health_success')
      elsif from_page == 'dashboard'
        redirect_to dashboard_path(date: @record.recorded_date), success: t('.health_success')
      else
        redirect_to records_path, success: t('.diary_success')
      end
    else
      set_all_visible_items
      flash.now[:danger] = t('.failure')
      render :edit, status: :unprocessable_content
    end
  end

  def update_diary
    @record.assign_attributes(processed_record_params)

    if @record.save(context: :diary)
      redirect_to records_path, success: t('.diary_success')
    else
      flash.now[:danger] = t('.failure')
      render :edit_diary, status: :unprocessable_content
    end
  end

  def destroy
    recorded_date = @record.recorded_date

    if @record.destroy
      redirect_to records_url(date: recorded_date),
                  danger: t('.success'),
                  status: :see_other
    else
      redirect_to records_url(date: recorded_date),
                  warning: t('.failure'),
                  status: :see_other
    end
  end

  def create_with_activity
    record = current_user.records.find_or_create_by!(recorded_date: @date)
    redirect_to new_record_activity_path(record, date: @date, hour: params[:hour])
  end

  def analytics
    @records = current_user.records
                           .order(recorded_date: :desc)
                           .limit(30)

    sleep_max = @records.joins(:record_values)
                        .where(record_values: { record_item_id: @items[:sleep].id })
                        .maximum('record_values.value').to_f
  
    @sleep_max = (sleep_max / 2.0).ceil * 2
    @sleep_max = [@sleep_max, 10].max
    @sleep_max_ticks = (@sleep_max / 2) + 1
  
    # 記録項目を取得
    @items = {
      sleep: current_user.record_items.find_by(name: '睡眠時間'),
      mood: current_user.record_items.find_by(name: '気分'),
      condition: current_user.record_items.find_by(name: '体調'),
      motivation: current_user.record_items.find_by(name: '意欲'),
      fatigue: current_user.record_items.find_by(name: '疲労感')
    }

    # グラフ用のデータを準備
    @charts = {
      sleep: sleep_chart_data,
      mood: chart_data(@items[:mood]),
      condition: chart_data(@items[:condition]),
      motivation: chart_data(@items[:motivation]),
      fatigue: chart_data(@items[:fatigue])
    }
  end

  private

  # 睡眠時間のグラフデータ
  def sleep_chart_data
    return {} if @items[:sleep].blank?
  
    current_user.records
      .joins(:record_values)
      .where(record_values: { record_item_id: @items[:sleep].id })
      .where('recorded_date >= ?', 30.days.ago)
      .order(recorded_date: :asc)
      .pluck(:recorded_date, 'record_values.value')
      .map { |date, value| [date.strftime('%Y-%m-%d'), calculate_sleep_hours(value)] }
      .to_h
  end

  # その他の項目のグラフデータ
  def chart_data(item)
    return {} if item.blank?
  
    current_user.records
      .joins(:record_values)
      .where(record_values: { record_item_id: item.id })
      .where('recorded_date >= ?', 30.days.ago)
      .order(recorded_date: :asc)
      .pluck(:recorded_date, 'record_values.value')
      .map { |date, value| [date.strftime('%Y-%m-%d'), value.to_f] }
      .to_h
  end

  # 睡眠時間を時間単位で計算
  def calculate_sleep_hours(time_range)
    return 0 if time_range.blank?
  
    match = time_range.match(/(\d{2}):(\d{2})-(\d{2}):(\d{2})/)
    return 0 unless match
  
    sleep_hour = match[1].to_i
    sleep_min = match[2].to_i
    wake_hour = match[3].to_i
    wake_min = match[4].to_i
  
    sleep_minutes = sleep_hour * 60 + sleep_min
    wake_minutes = wake_hour * 60 + wake_min
    wake_minutes += 24 * 60 if wake_minutes < sleep_minutes
  
    duration_minutes = wake_minutes - sleep_minutes
    result = (duration_minutes / 60.0).round(1)
  
    result
  end

  def processed_record_params
    params_hash = record_params.to_h.deep_dup
    process_time_ranges(params_hash)
    params_hash
  end

  def find_or_build_record
    record_params_hash = processed_record_params

    current_user.records.find_or_initialize_by(
      recorded_date: record_params_hash[:recorded_date]
    )
  end

  def assign_attributes_to_record
    @record.assign_attributes(processed_record_params)
  end

  def save_record
    if params[:record][:redirect_to_dashboard] == "true"
      @record.save
    else
      @record.save(context: :diary)
    end
  end

  def redirect_after_save
    if params[:record][:redirect_to_dashboard] == "true"
      redirect_to dashboard_path(date: @record.recorded_date),
                  success: t('.health_success')
    else
      redirect_to records_path,
                  success: t('.diary_success')
    end
  end

  def render_after_failure
    set_all_visible_items
    flash.now[:danger] = t('.failure')
    render :new, status: :unprocessable_content
  end

  def find_record_item(attributes)
    if attributes["id"].present?
      RecordValue.find_by(id: attributes["id"])&.record_item
    elsif attributes["record_item_id"].present?
      RecordItem.find_by(id: attributes["record_item_id"])
    end
  end

  def build_time_range(attributes)
    sleep_time = Time.zone.parse(
      "#{attributes['sleep_hour']}:#{attributes['sleep_minute']}"
    )
    wake_time = Time.zone.parse(
      "#{attributes['wake_hour']}:#{attributes['wake_minute']}"
    )

    wake_time += 1.day if wake_time < sleep_time

    "#{sleep_time.strftime('%H:%M')}-#{wake_time.strftime('%H:%M')}"
  end

  def process_time_ranges(params_hash)
    return unless params_hash["record_values_attributes"]

    params_hash["record_values_attributes"].each_value do |attributes|
      next unless attributes["sleep_hour"].present? && attributes["wake_hour"].present?

      attributes["value"] = build_time_range(attributes)
    end
  end

  def build_missing_record_values(record)
    current_user.record_items.where(is_default_visible: true).find_each do |item|
      record.record_values.find_or_initialize_by(record_item: item)
    end
  end

  def set_date
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
  end

  def set_record
    @record = current_user.records.find(params[:id])
  end

  def set_record_for_date
    date = params[:date] ? Date.parse(params[:date]) : Date.current
    @record = current_user.records.find_or_initialize_by(recorded_date: date)
  end

  def authorize_user!
    return if @record && @record.user_id == current_user.id

    respond_to do |format|
      format.html { redirect_to records_path, warning: t('records.authorize.forbidden') }
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
      @record.record_values.build(record_item: item) unless @record.record_values.any? { |rv| rv.record_item_id == item.id }
    end
  end

  def set_current_display_date
    @display_date = params[:date] ? Date.parse(params[:date]) : Date.current
  rescue ArgumentError
    @display_date = Date.current
  end

  def record_params
    params.require(:record).permit(
      :recorded_date,
      :diary_memo,
      record_values_attributes: %i[
        id
        record_item_id
        _destroy
        value
        sleep_hour
        sleep_minute
        wake_hour
        wake_minute
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
