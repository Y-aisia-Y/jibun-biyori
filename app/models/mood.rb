class Mood < ApplicationRecord
  belongs_to :record

  validates :rating, presence: true, numericality: { in: 1..5 }
  validates :comment, length: { maximum: 255 }, allow_blank: true

  # 評価表示（仮）
  def rating_text
    case rating
    when 5 then 'とても良い'
    when 4 then '良い'
    when 3 then '普通'
    when 2 then '少し悪い'
    when 1 then '悪い'
    else '未評価'
    end
  end
end
