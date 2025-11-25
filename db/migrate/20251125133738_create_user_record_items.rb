class CreateUserRecordItems < ActiveRecord::Migration[7.1]
  def change
    create_table :user_record_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :record_item, null: false, foreign_key: true
      t.boolean :is_visible
      t.integer :display_order

      t.timestamps
    end
  end
end
