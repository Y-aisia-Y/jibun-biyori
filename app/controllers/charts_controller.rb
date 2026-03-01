# frozen_string_literal: true

class ChartsController < ApplicationController
  before_action :authenticate_user!

  # システム項目の名前を定数で定義
  SYSTEM_ITEM_NAMES = %w[睡眠時間 気分 体調 意欲 疲労感].freeze

  def index
    @week_start = calculate_week_start
    @week_end = @week_start + 6.days
    @week_dates = (@week_start..@week_end).to_a

    setup_items
    setup_records
    build_chart_data
    calculate_sleep_metrics
  end

  private

  # 週の開始日を計算
  def calculate_week_start
    if params[:week_start].present?
      Date.parse(params[:week_start])
    else
      Date.current.beginning_of_week(:sunday)
    end
  end

  # 項目を設定
  def setup_items
    @visible_items = current_user.record_items
                                 .where(is_default_visible: true)
                                 .order(:display_order)

    @graph_items = current_user.record_items
                               .where(
                                 is_default_visible: true,
                                 name: SYSTEM_ITEM_NAMES
                               )
                               .order(:display_order)

    @items = {
      sleep: current_user.record_items.find_by(name: "睡眠時間"),
      mood: current_user.record_items.find_by(name: "気分"),
      condition: current_user.record_items.find_by(name: "体調"),
      motivation: current_user.record_items.find_by(name: "意欲"),
      fatigue: current_user.record_items.find_by(name: "疲労感")
    }

    # テーブル用の変数を設定
    @sleep_item      = @items[:sleep]
    @mood_item       = @items[:mood]
    @condition_item  = @items[:condition]
    @motivation_item = @items[:motivation]
    @fatigue_item    = @items[:fatigue]
  end

  # レコードを設定
  def setup_records
    @records_for_graph = current_user.records
                                     .includes(:record_values)
                                     .where(recorded_date: @week_start..@week_end)
                                     .order(:recorded_date)

    records_in_week = current_user.records
                                  .includes(:record_values)
                                  .where(recorded_date: @week_start..@week_end)
                                  .index_by(&:recorded_date)

    @records = @week_dates.map { |date| records_in_week[date] }
    @records_in_week = records_in_week
  end

  # グラフデータを構築
  def build_chart_data
    @charts = {}
    @graph_items.each do |item|
      @charts[item.name.to_sym] = build_item_chart_data(item)
    end
  end

  # 各項目のグラフデータを構築
  def build_item_chart_data(item)
    chart_data = {}

    @week_dates.each do |date|
      record = @records_in_week[date]
      value = extract_record_value(record, item)
      chart_data[date.strftime('%m/%d')] = value
    end

    chart_data
  end

  # レコードから値を抽出
  def extract_record_value(record, item)
    return nil unless record

    record_value = record.record_values.find_by(record_item: item)
    return nil if record_value&.value.blank?

    if item.name == "睡眠時間"
      calculate_sleep_hours(record_value.value)
    else
      record_value.value.to_f
    end
  end

  # 睡眠時間のグラフ用の最大値を計算
  def calculate_sleep_metrics
    sleep_values = @charts[:睡眠時間]&.values&.compact || []

    if sleep_values.any?
      max_value = sleep_values.max
      @sleep_max = ((max_value / 2.0).ceil * 2) + 2
      @sleep_max_ticks = (@sleep_max / 2) + 1
    else
      @sleep_max = 10
      @sleep_max_ticks = 6
    end
  end

  # 睡眠時間を計算
  def calculate_sleep_hours(time_range)
    return 0 if time_range.blank?

    match = time_range.match(/(\d{2}):(\d{2})-(\d{2}):(\d{2})/)
    return 0 unless match

    sleep_hour = match[1].to_i
    sleep_min = match[2].to_i
    wake_hour = match[3].to_i
    wake_min = match[4].to_i

    sleep_minutes = (sleep_hour * 60) + sleep_min
    wake_minutes = (wake_hour * 60) + wake_min
    wake_minutes += 24 * 60 if wake_minutes < sleep_minutes

    duration_minutes = wake_minutes - sleep_minutes
    (duration_minutes / 60.0).round(1)
  end
end
