class Rails < ActiveRecord::Migration[7.1]
  def up
    RecordItem.find_by(name: "疲労感")&.update!(input_type: :five_step)
    RecordItem.find_by(name: "意欲")&.update!(input_type: :five_step)
  end

  def down
  end
end
