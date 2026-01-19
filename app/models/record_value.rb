class RecordValue < ApplicationRecord
  belongs_to :record
  belongs_to :record_item

  # 仮想属性(フォームからの入力を受け取る)
  attr_accessor :sleep_hour, :sleep_minute, :wake_hour, :wake_minute

  # before_saveでvalueに統合
  before_save :set_time_range_value

  # valueから時刻を抽出
  def sleep_time
    return nil unless value.present? && value.include?('-')
    
    time_str = value.split('-').first
    Time.zone.parse(time_str)
  end

  def wake_time
    return nil unless value.present? && value.include?('-')
    
    time_str = value.split('-').last
    Time.zone.parse(time_str)
  end

  private

  def set_time_range_value
    return unless record_item&.input_type == "time_range"
    
    # 仮想属性から時刻を構築
    if sleep_hour.present? && sleep_minute.present? && 
       wake_hour.present? && wake_minute.present?
      
      sleep_time = Time.zone.parse("#{sleep_hour}:#{sleep_minute}")
      wake_time = Time.zone.parse("#{wake_hour}:#{wake_minute}")
      
      # 日をまたぐ場合の処理
      wake_time += 1.day if wake_time < sleep_time
      
      self.value = "#{sleep_time.strftime('%H:%M')}-#{wake_time.strftime('%H:%M')}"
    end
  end
end
