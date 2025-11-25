class Record < ApplicationRecord
  belongs_to :user

  has_many :activities, dependent: :destroy
  has_many :record_values, dependent: :destroy
end
