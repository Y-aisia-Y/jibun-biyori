class ActivityDecorator < ApplicationDecorator
  delegate_all

  # 開始位置(px)を計算
  def top_position
    (start_time.min / 60.0) * 80
  end

  # 高さ(px)を計算
  def height
    (duration_in_minutes / 60.0) * 80
  end

  # 時間の範囲を表示用にフォーマット
  def time_range
    "#{start_time.strftime('%H:%M')} - #{end_time.strftime('%H:%M')}"
  end

  private

  # 活動時間(分)を計算
  def duration_in_minutes
    ((end_time - start_time) / 60).to_i
  end
end
