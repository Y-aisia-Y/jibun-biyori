class ChartsController < ApplicationController
  before_action :authenticate_user!

  def index
    # 項目の定義
    @items = {
      sleep:      current_user.record_items.find_by(name: "睡眠時間"),
      mood:       current_user.record_items.find_by(name: "気分"),
      condition:  current_user.record_items.find_by(name: "体調"),
      motivation: current_user.record_items.find_by(name: "意欲"),
      fatigue:    current_user.record_items.find_by(name: "疲労感")
    }

    # テーブル用の変数を追加
    @sleep_item      = @items[:sleep]
    @mood_item       = @items[:mood]
    @condition_item  = @items[:condition]
    @motivation_item = @items[:motivation]
    @fatigue_item    = @items[:fatigue]

    # 日付を新しい順に並び替え（グラフ用）
    @records_for_graph = current_user.records
                                     .where(recorded_date: 30.days.ago..Date.current)
                                     .order(:recorded_date)

    # 日付を新しい順に並び替え（テーブル用）
    @records = current_user.records
                           .where(recorded_date: 30.days.ago..Date.current)
                           .order(recorded_date: :desc)

    # 各項目ごとのグラフデータを作成
    @charts = {}
    @items.each do |key, item|
      next unless item
      
      @charts[key] = @records_for_graph.each_with_object({}) do |record, hash|
        value = record.record_values.find_by(record_item: item)&.value
        
        # 睡眠時間の場合は計算する
        if key == :sleep && value.present?
          hash[record.recorded_date] = calculate_sleep_hours(value)
        elsif value.present?
          hash[record.recorded_date] = value.to_f
        end
      end
    end
  end

  private

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
    (duration_minutes / 60.0).round(1)
  end
end
