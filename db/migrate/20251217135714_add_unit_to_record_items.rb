class AddUnitToRecordItems < ActiveRecord::Migration[7.1]
  def change
    add_column :record_items, :unit, :string
  end
end
