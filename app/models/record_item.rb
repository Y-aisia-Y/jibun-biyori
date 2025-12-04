class RecordItem < ApplicationRecord

  has_many :record_values
    
  enum input_type: { 
    five_step: 0,   # 5段階評価(0)
    numeric: 1,     # 数値入力(1)
    text: 2,        # テキストエリア(2)
    checkbox: 3     # チェックボックス(3)
  }

  has_many :record_values, dependent: :destroy
  has_many :user_record_items, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :input_type, presence: true
end
