class Mood < ApplicationRecord
  belongs_to :record

  validates :rating, presence: true,
    numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  validates :comment, length: { maximum: 255 }, allow_blank: true
end
