class CreateRecordValues < ActiveRecord::Migration[7.1]
  def change
    create_table :record_values do |t|
      t.references :record, null: false, foreign_key: true
      t.references :record_item, null: false, foreign_key: true
      t.string :value

      t.timestamps
    end
  end
end
