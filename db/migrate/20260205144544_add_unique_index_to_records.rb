class AddUniqueIndexToRecords < ActiveRecord::Migration[7.1]
  def change
    add_index :records, [:user_id, :recorded_date], unique: true
  end
end
