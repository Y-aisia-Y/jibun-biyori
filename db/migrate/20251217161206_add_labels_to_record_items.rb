class AddLabelsToRecordItems < ActiveRecord::Migration[7.1]
  def change
    add_column :record_items, :label1, :string
    add_column :record_items, :label2, :string
  end
end
