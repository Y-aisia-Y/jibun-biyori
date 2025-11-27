class RecordItem < ApplicationRecord
    
  module InputType
    # 数値入力
    NUMBER = 1
    # 選択肢からの単一選択
    SELECT = 2
    # テキスト入力
    TEXT = 3
    # 評価スライダー
    RATING = 4
  end

  has_many :record_values, dependent: :destroy
  has_many :user_record_items, dependent: :destroy
end
