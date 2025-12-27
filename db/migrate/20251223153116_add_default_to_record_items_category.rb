class AddDefaultToRecordItemsCategory < ActiveRecord::Migration[7.1]
  def up
    execute <<~SQL
      UPDATE record_items
      SET category = 'custom'
      WHERE category IS NULL
    SQL

    change_column_null :record_items, :category, false
    change_column_default :record_items, :category, 'custom'
  end

  def down
    change_column_default :record_items, :category, nil
    change_column_null :record_items, :category, true
  end
end
