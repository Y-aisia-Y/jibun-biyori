class ChartsController < ApplicationController
  before_action :authenticate_user!

  # システム項目の名前を定数で定義
  SYSTEM_ITEM_NAMES = %w[睡眠時間 気分 体調 意欲 疲労感].freeze

  def index
    # 表示する項目を取得(is_default_visible が true の項目のみ)
    @visible_items = current_user.record_items
                                 .where(is_default_visible: true)
                                 .order(:display_order)
    
    # グラフ用のシステム項目のみを取得（名前で絞り込み）
    @graph_items = current_user.record_items
                               .where(
                                 is_default_visible: true,
                                 name: SYSTEM_ITEM_NAMES
                               )
                               .order(:display_order)
    
    # テーブル表示用の項目を取得
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
                                     .includes(:record_values)
                                     .where(recorded_date: 30.days.ago..Date.current)
                                     .order(:recorded_date)

    # 日付を新しい順に並び替え（テーブル用）
    @records = current_user.records
                           .includes(:record_values)
                           .where(recorded_date: 30.days.ago..Date.current)
                           .order(recorded_date: :desc)

    # グラフ用のシステム項目のみでグラフデータを作成
    @charts = {}
    @graph_items.each do |item|
      chart_data = @records_for_graph.each_with_object({}) do |record, hash|
        value = record.record_values.find_by(record_item: item)&.value
        
        # 睡眠時間の場合は計算する
        if item.name == "睡眠時間" && value.present?
          hash[record.recorded_date] = calculate_sleep_hours(value)
        elsif value.present?
          hash[record.recorded_date] = value.to_f
        end
      end
      
      # データが存在する場合のみ追加
      @charts[item.name.to_sym] = chart_data if chart_data.present?
    end

    # 睡眠時間のグラフ用の最大値を計算
    sleep_values = @charts[:睡眠時間]&.values || []
    if sleep_values.any?
      max_value = sleep_values.max
      @sleep_max = ((max_value / 2.0).ceil * 2) + 2
      @sleep_max_ticks = @sleep_max / 2 + 1
    else
      @sleep_max = 10
      @sleep_max_ticks = 6
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
