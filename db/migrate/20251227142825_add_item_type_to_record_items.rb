class AddItemTypeToRecordItems < ActiveRecord::Migration[7.1]
  def change
    add_column :record_items, :item_type, :integer, default: 0, null: false
    add_index  :record_items, :item_type
  end
end
