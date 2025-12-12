class Record < ApplicationRecord
  belongs_to :user

  has_many :activities, dependent: :destroy
  has_many :record_values, dependent: :destroy
  has_many :activities, dependent: :destroy

  accepts_nested_attributes_for :record_values, allow_destroy: true
  
  validates :recorded_date, presence: true, uniqueness: { scope: :user_id }
end
