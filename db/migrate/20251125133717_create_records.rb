class CreateRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :records do |t|
      t.references :user, null: false, foreign_key: true
      t.date :recorded_date
      t.text :diary_memo

      t.timestamps
    end
  end
end
