class RecordValue < ApplicationRecord
  belongs_to :record
  belongs_to :record_item
end
