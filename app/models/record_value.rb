class RecordValue < ApplicationRecord
  belongs_to :record
  belongs_to :record_item
  
  validates :record_item_id, uniqueness: { scope: :record_id }
  validates :value, presence: true
end
