class RecordItem < ApplicationRecord
  belongs_to :user
  has_many :record_values, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :input_type, presence: true

  enum input_type: {
    five_step: 0,
    numeric: 1,
    text: 2,
    checkbox: 3,
    time_range: 4
  }

  # デフォルト値
  def default_value
    case input_type
    when 'checkbox' then '0'
    when 'time_range' then '3'
    else
      ''
    end
  end

  def time_range?
    input_type == 'time_range'
  end
end