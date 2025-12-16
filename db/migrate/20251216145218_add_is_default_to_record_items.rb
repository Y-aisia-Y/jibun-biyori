class AddIsDefaultToRecordItems < ActiveRecord::Migration[7.1]
  def change
    add_column :record_items, :is_default, :boolean, null: false, default: false
  end
end
