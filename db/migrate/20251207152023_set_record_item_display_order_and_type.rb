class SetRecordItemDisplayOrderAndType < ActiveRecord::Migration[7.1]
  def up
    items = RecordItem.where(name: ["睡眠時間(h)", "気分", "意欲", "疲労度"]).index_by(&:name)

    # 睡眠時間
    if items["睡眠時間(h)"]
      items["睡眠時間(h)"].update!(
        name: '睡眠時間', 
        input_type: 4,
        display_order: 1
      )
    end
    
    # 気分
    if items["気分"]
      items["気分"].update!(
        input_type: 0,
        display_order: 2
      )
    end

    # 意欲
    if items["意欲"]
      items["意欲"].update!(
        input_type: 0,
        display_order: 3
      )
    end

    # 疲労度
    if items["疲労度"]
      items["疲労度"].update!(
        name: '疲労感', 
        input_type: 0,
        display_order: 4
      )
    end
  end

  def down
    # ロールバック処理が必要な場合はここに記述
    items = RecordItem.where(name: ["睡眠時間", "気分", "意欲", "疲労感"]).index_by(&:name)

    if items["睡眠時間"]
      items["睡眠時間"].update!(
        name: '睡眠時間(h)', 
        input_type: 1,
        display_order: nil
      )
    end
    
    if items["疲労感"]
      items["疲労感"].update!(
        name: '疲労度',
        display_order: nil
      )
    end
  end
end
