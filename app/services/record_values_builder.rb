class RecordValuesBuilder
  def initialize(record, user)
    @record = record
    @user = user
  end

  def call
    record_items.each do |item|
      next if @record.record_values.any? { |v| v.record_item_id == item.id }
      @record.record_values.build(record_item: item)
    end
  end

  private

  def record_items
    @record_items ||= @user.record_items
                           .where(is_default_visible: true)
                           .order(:display_order)
  end
end
