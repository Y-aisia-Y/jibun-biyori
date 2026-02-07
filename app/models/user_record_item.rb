# frozen_string_literal: true

class UserRecordItem < ApplicationRecord
  belongs_to :user
  belongs_to :record_item
end
