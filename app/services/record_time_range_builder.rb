# frozen_string_literal: true

class RecordTimeRangeBuilder
  def initialize(params)
    @params = params
  end

  def call
    params_hash = @params.to_h

    return params_hash unless params_hash[:record_values_attributes]

    params_hash[:record_values_attributes].each do |key, rv_attr|
      next unless time_range_record?(rv_attr)

      sleep_time = rv_attr[:sleep_time].presence || "00:00"
      wake_time = rv_attr[:wake_time].presence || "00:00"
      params_hash[:record_values_attributes][key][:value] = "#{sleep_time} - #{wake_time}"
    end

    params_hash
  end

  private

  def time_range_record?(rv_attr)
    return false unless rv_attr[:sleep_time].present? && rv_attr[:wake_time].present?

    record_item = RecordItem.find_by(id: rv_attr[:record_item_id])
    record_item&.input_type == "time_range"
  end
end
