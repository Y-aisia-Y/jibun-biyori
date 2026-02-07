class AddUniqueIndexToRecordItems < ActiveRecord::Migration[7.0]
  def change
    add_index :record_items, [:user_id, :name], unique: true
  end
end
