# frozen_string_literal: true

module AnalyticsConcern
  extend ActiveSupport::Concern

  private

  # 最近の記録を取得
  def fetch_recent_records
    current_user.records
                .order(recorded_date: :desc)
                .limit(30)
  end

  # 記録項目を取得
  def fetch_record_items
    {
      sleep: current_user.record_items.find_by(name: '睡眠時間'),
      mood: current_user.record_items.find_by(name: '気分'),
      condition: current_user.record_items.find_by(name: '体調'),
      motivation: current_user.record_items.find_by(name: '意欲'),
      fatigue: current_user.record_items.find_by(name: '疲労感')
    }
  end

  # グラフデータを構築
  def build_analytics_charts
    {
      sleep: sleep_chart_data,
      mood: chart_data(@items[:mood]),
      condition: chart_data(@items[:condition]),
      motivation: chart_data(@items[:motivation]),
      fatigue: chart_data(@items[:fatigue])
    }
  end

  # 睡眠グラフの設定を計算
  def calculate_sleep_chart_settings
    return set_default_sleep_settings if @items[:sleep].blank?

    sleep_max = @records.joins(:record_values)
                        .where(record_values: { record_item_id: @items[:sleep].id })
                        .maximum('record_values.value').to_f

    @sleep_max = [(sleep_max / 2.0).ceil * 2, 10].max
    @sleep_max_ticks = (@sleep_max / 2) + 1
  end

  # デフォルトの睡眠設定
  def set_default_sleep_settings
    @sleep_max = 10
    @sleep_max_ticks = 6
  end

  # 睡眠時間のグラフデータ
  def sleep_chart_data
    return {} if @items[:sleep].blank?

    current_user.records
                .joins(:record_values)
                .where(record_values: { record_item_id: @items[:sleep].id })
                .where(recorded_date: 30.days.ago..)
                .order(recorded_date: :asc)
                .pluck(:recorded_date, 'record_values.value')
                .to_h { |date, value| [date.strftime('%Y-%m-%d'), calculate_sleep_hours(value)] }
  end

  # その他の項目のグラフデータ
  def chart_data(item)
    return {} if item.blank?

    current_user.records
                .joins(:record_values)
                .where(record_values: { record_item_id: item.id })
                .where(recorded_date: 30.days.ago..)
                .order(recorded_date: :asc)
                .pluck(:recorded_date, 'record_values.value')
                .to_h { |date, value| [date.strftime('%Y-%m-%d'), value.to_f] }
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

    sleep_minutes = (sleep_hour * 60) + sleep_min
    wake_minutes = (wake_hour * 60) + wake_min
    wake_minutes += 24 * 60 if wake_minutes < sleep_minutes

    ((wake_minutes - sleep_minutes) / 60.0).round(1)
  end
end
