class Activity < ApplicationRecord
  PIXELS_PER_HOUR = 80
  PIXELS_PER_MINUTE = PIXELS_PER_HOUR / 60.0

  belongs_to :record

  # タイムライン全体での位置(元のメソッド)
  def top_position
    return 0 unless start_time
    total_minutes = start_time.hour * 60 + start_time.min
    total_minutes * PIXELS_PER_MINUTE
  end

  # 全体の高さ(元のメソッド)
  def height
    return 0 unless start_time && end_time
    duration_minutes = ((end_time - start_time) / 60).to_i
    duration_minutes * PIXELS_PER_MINUTE
  end

  # その時間ブロック内での開始位置のオフセット
  def offset_from_hour_start
    return 0 unless start_time
    start_time.min * PIXELS_PER_MINUTE
  end

  # その時間ブロック内での高さ
  # 活動が複数時間にまたがる場合は、最初の時間ブロック内の高さのみ
  def height_in_hour
    return 0 unless start_time && end_time
    
    # 同じ時間内で終わる場合
    if start_time.hour == end_time.hour
      duration_minutes = ((end_time - start_time) / 60).to_i
      return duration_minutes * PIXELS_PER_MINUTE
    end
    
    # 次の時間にまたがる場合は、その時間の残り分
    remaining_minutes = 60 - start_time.min
    remaining_minutes * PIXELS_PER_MINUTE
  end
end
