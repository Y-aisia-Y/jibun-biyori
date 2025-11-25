class CreateRecordItems < ActiveRecord::Migration[7.1]
  def change
    create_table :record_items do |t|
      t.string :name
      t.integer :input_type
      t.boolean :is_default_visible

      t.timestamps
    end
  end
end
