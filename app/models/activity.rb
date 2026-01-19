class Activity < ApplicationRecord
  PIXELS_PER_HOUR = 80
  PIXELS_PER_MINUTE = PIXELS_PER_HOUR / 60.0

  belongs_to :record

  def top_position
    return 0 unless start_time
    total_minutes = start_time.hour * 60 + start_time.min
    total_minutes * PIXELS_PER_MINUTE
  end

  def height
    return 0 unless start_time && end_time
    duration_minutes = ((end_time - start_time) / 60).to_i
    duration_minutes * PIXELS_PER_MINUTE
  end

  def time_range
    return '時刻未設定' unless start_time.present? && end_time.present?
    "#{start_time.strftime('%H:%M')} - #{end_time.strftime('%H:%M')}"
  end
end
