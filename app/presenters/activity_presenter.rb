# frozen_string_literal: true

class ActivityPresenter
  attr_reader :activity, :current_hour

  def initialize(activity, current_hour)
    @activity = activity
    @current_hour = current_hour
  end

  def continuation?
    activity.start_time.hour < current_hour
  end

  def start?
    activity.start_time.hour == current_hour
  end

  def end?
    activity.end_time.hour == current_hour
  end

  def time_range
    start_time = activity.start_time
    end_time = activity.end_time

    # to_date を使用
    display_start = [start_time, Time.zone.parse("#{start_time.to_date} #{current_hour}:00")].max
    display_end = [end_time, Time.zone.parse("#{start_time.to_date} #{current_hour + 1}:00")].min

    "#{display_start.strftime('%H:%M')} - #{display_end.strftime('%H:%M')}"
  end

  delegate :content, to: :activity
end
