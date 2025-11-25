class RecordItem < ApplicationRecord
    
  has_many :record_values, dependent: :destroy
  has_many :user_record_items, dependent: :destroy
end
