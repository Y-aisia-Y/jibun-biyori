class RecordValue < ApplicationRecord
  belongs_to :record
  belongs_to :record_item

  attr_accessor :sleep_time, :wake_time
  before_validation :set_time_range_value
  
  validates :record_item_id, presence: true
  validate :validate_value_based_on_input_type
  
  private
  
  def set_time_range_value
    if record_item&.time_range? && sleep_time.present? && wake_time.present?
      self.value = "#{sleep_time} - #{wake_time}"
    end
  end

  def validate_value_based_on_input_type
    return unless record_item
  
    case record_item.input_type.to_sym
    when :five_step
      if value.present? && (value.to_i < 1 || value.to_i > 5)
        errors.add(:value, 'は1から5の範囲で入力してください')
      end
    when :numeric
      if value.present? && !value.to_s.match?(/\A\d+(\.\d+)?\z/)
        errors.add(:value, '数値で入力してください')
      end
    when :time_range
      if value.present?
        sleep_time, wake_time = value.split('-').map(&:strip)
        if sleep_time.blank? || wake_time.blank?
          errors.add(:value, '就寝時刻と起床時刻は両方入力してください')
        end
      end
    end
  end
end
