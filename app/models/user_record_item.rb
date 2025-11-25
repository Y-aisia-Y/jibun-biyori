class UserRecordItem < ApplicationRecord
  belongs_to :user
  belongs_to :record_item
end
