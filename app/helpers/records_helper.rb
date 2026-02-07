# frozen_string_literal: true

module RecordsHelper
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

    # この時間帯の開始時刻
    hour_start = Time.zone.parse("#{start_time.to_date} #{current_hour}:00")
    # この時間帯の終了時刻
    hour_end = hour_start + 1.hour

    # 表示する範囲を計算
    display_start = [start_time, hour_start].max
    display_end = [end_time, hour_end].min

    # 終了時刻がちょうど時間の区切りの場合は表示しない
    return "display: none;" if display_start >= display_end

    # 時間帯の開始からの位置(%)
    start_percent = ((display_start - hour_start) / 3600.0 * 100).round(2)
    # 高さ(%)
    height_percent = ((display_end - display_start) / 3600.0 * 100).round(2)

    "top: #{start_percent}%; height: #{height_percent}%;"
  end

  def format_time_range(start_time, end_time)
    "#{start_time.strftime('%H:%M')} - #{end_time.strftime('%H:%M')}"
  end
end
