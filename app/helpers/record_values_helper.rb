# frozen_string_literal: true

module RecordValuesHelper
  def record_value_for(record, item)
    record.record_values.find { |rv| rv.record_item_id == item.id } ||
      record.record_values.build(record_item: item)
  end
end
