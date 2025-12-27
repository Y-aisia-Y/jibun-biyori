class Record < ApplicationRecord
  belongs_to :user

  has_many :activities, dependent: :destroy
  has_many :record_values, dependent: :destroy

  has_one :mood, dependent: :destroy

  accepts_nested_attributes_for :mood
  accepts_nested_attributes_for :record_values, allow_destroy: true

  validates :recorded_date, presence: true, uniqueness: { scope: :user_id }

  def system_value_for(record_item)
    raise ArgumentError, "system item only" unless record_item.system?

    record_values.find_by(record_item: record_item) ||
      record_values.build(record_item: record_item)
  end

  def system_items
    RecordItem.system.order(:display_order)
  end
end
