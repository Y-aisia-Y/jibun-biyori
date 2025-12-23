class RecordItem < ApplicationRecord
  belongs_to :user
  has_many :record_values, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :input_type, presence: true
  validates :category, presence: true

  enum category: {
    system: "system",
    custom: "custom"
  }

  enum input_type: {
    five_step: 0,
    numeric: 1,
    text: 2,
    checkbox: 3,
    time_range: 4
  }

  scope :visible_ordered,
        -> { where(is_default_visible: true).order(:display_order) }

  # system / custom 
  def deletable?
    custom?
  end

  def graphable?
    system?
  end

  # デフォルト値（system 項目向け）
  def default_value
    return '' unless system?

    case input_type
    when 'checkbox' then '0'
    when 'time_range' then '3'
    else
      ''
    end
  end
end
