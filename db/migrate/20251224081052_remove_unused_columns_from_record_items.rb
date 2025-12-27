class RemoveUnusedColumnsFromRecordItems < ActiveRecord::Migration[7.1]
  def change
    remove_column :record_items, :is_default, :boolean
    remove_column :record_items, :label1, :string
    remove_column :record_items, :label2, :string
  end
end
