class RecordItem < ApplicationRecord
  belongs_to :user
  has_many :record_values, dependent: :destroy

  enum input_type: {
    five_step: 0,
    numeric: 1,
    text: 2,
    checkbox: 3,
    time_range: 4
  }

  enum category: {
    default: "default",
    custom: "custom"
  }

  enum item_type: {
    system: 0,
    user_defined: 1
  }

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :input_type, presence: true
  validates :category, presence: true
  validates :item_type, presence: true

  scope :visible, -> { where(is_default_visible: true).order(:display_order) }
  scope :defaults, -> { where(category: "default") }
  scope :customs,  -> { where(category: "custom") }

  def deletable?
    custom?
  end
end
