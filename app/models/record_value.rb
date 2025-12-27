class RecordValue < ApplicationRecord
  belongs_to :record
  belongs_to :record_item

  before_save :set_time_range_value

  private

  def set_time_range_value
    return unless record_item&.input_type == "time_range"
    return if sleep_time.blank? || wake_time.blank?

    self.value = "#{sleep_time.strftime('%H:%M')}-#{wake_time.strftime('%H:%M')}"
  end
end
