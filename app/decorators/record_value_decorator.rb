# frozen_string_literal: true

class RecordValueDecorator < Draper::Decorator
  delegate_all

  # 時間範囲の就寝時刻(時)
  def sleep_hour
    return 0 unless object.sleep_time

    object.sleep_time.hour
  end

  # 時間範囲の就寝時刻(分)
  def sleep_minute
    return 0 unless object.sleep_time

    (object.sleep_time.min / 5) * 5
  end

  # 時間範囲の起床時刻(時)
  def wake_hour
    return 0 unless object.wake_time

    object.wake_time.hour
  end

  # 時間範囲の起床時刻(分)
  def wake_minute
    return 0 unless object.wake_time

    (object.wake_time.min / 5) * 5
  end

  # 時間のセレクトボックス用オプション(0-23時)
  def hour_options
    (0..23).map { |h| [format('%02d', h), h] }
  end

  # 分のセレクトボックス用オプション(5分刻み)
  def minute_options
    (0..11).map { |m| [format('%02d', m * 5), m * 5] }
  end

  # 睡眠時間の計算(時間単位)
  def sleep_duration
    return nil unless object.sleep_time && object.wake_time

    duration_seconds = object.wake_time - object.sleep_time
    (duration_seconds / 3600).round(1)
  end

  # 睡眠時間の表示用テキスト
  def sleep_duration_text
    return '' unless sleep_duration

    "睡眠時間: #{sleep_duration}時間"
  end
end
