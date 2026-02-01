class ChangeDisplayOrderNotNullInRecordItems < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      UPDATE record_items 
      SET display_order = 999 
      WHERE display_order IS NULL
    SQL
    change_column_null :record_items, :display_order, false
  end

  def down
    change_column_null :record_items, :display_order, true
  end
end