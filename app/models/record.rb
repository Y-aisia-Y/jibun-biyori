class Record < ApplicationRecord
  belongs_to :user

  has_many :activities, dependent: :destroy
  has_many :record_values, dependent: :destroy

  has_one :mood, dependent: :destroy

  accepts_nested_attributes_for :mood
  accepts_nested_attributes_for :record_values, allow_destroy: true

  validates :recorded_date, presence: true, uniqueness: { scope: :user_id }
  
  # システム項目を取得するメソッド
  def system_items
    user.record_items.system_items.visible.ordered
  end
  
  # 指定されたシステム項目の値を取得
  def system_value_for(item)
    record_values.find_by(record_item: item)
  end
end
