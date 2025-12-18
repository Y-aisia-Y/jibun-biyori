class AddDefaultToIsDefaultVisible < ActiveRecord::Migration[7.1]
  def up
    change_column_default :record_items, :is_default_visible, true
    execute "UPDATE record_items SET is_default_visible = true WHERE is_default_visible IS NULL"
  end

  def down
    change_column_default :record_items, :is_default_visible, nil
  end
end
