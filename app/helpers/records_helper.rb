# frozen_string_literal: true

module RecordsHelper
  # 睡眠時間（テーブル用）
  def format_sleep_duration(time_range)
    return '' if time_range.blank?

    match = time_range.match(/(\d{2}):(\d{2})-(\d{2}):(\d{2})/)
    return time_range unless match

    sleep_hour = match[1].to_i
    sleep_min = match[2].to_i
    wake_hour = match[3].to_i
    wake_min = match[4].to_i

    sleep_minutes = (sleep_hour * 60) + sleep_min
    wake_minutes = (wake_hour * 60) + wake_min

    wake_minutes += 24 * 60 if wake_minutes < sleep_minutes

    duration_minutes = wake_minutes - sleep_minutes
    hours = duration_minutes / 60
    minutes = duration_minutes % 60

    if minutes.zero?
      "#{hours}時間"
    else
      "#{hours}時間#{minutes}分"
    end
  end

  def activity_marker_class(presenter)
    classes = ['activity-marker']
    classes << 'activity-marker-start' if presenter.is_start?
    classes << 'activity-marker-end' if presenter.is_end?
    classes << 'activity-marker-continuation' if presenter.is_continuation?
    classes.join(' ')
  end

  def activity_marker_style(presenter)
    start_time = presenter.activity.start_time
    end_time = presenter.activity.end_time
    current_hour = presenter.current_hour

    hour_start = Time.zone.parse("#{start_time.to_date} #{current_hour}:00")
    hour_end = hour_start + 1.hour

    display_start = [start_time, hour_start].max
    display_end = [end_time, hour_end].min

    return "display: none;" if display_start >= display_end

    start_percent = ((display_start - hour_start) / 3600.0 * 100).round(2)
    height_percent = ((display_end - display_start) / 3600.0 * 100).round(2)

    "top: #{start_percent}%; height: #{height_percent}%;"
  end

  def format_time_range(start_time, end_time)
    "#{start_time.strftime('%H:%M')} - #{end_time.strftime('%H:%M')}"
  end
end
