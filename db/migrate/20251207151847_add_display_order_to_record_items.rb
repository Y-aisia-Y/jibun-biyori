class AddDisplayOrderToRecordItems < ActiveRecord::Migration[7.1]
  def change
    add_column :record_items, :display_order, :integer, null: true, default: nil
    add_index :record_items, :display_order
  end
end
