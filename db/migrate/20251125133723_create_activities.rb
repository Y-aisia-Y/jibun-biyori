class CreateActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :activities do |t|
      t.references :record, null: false, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.text :content

      t.timestamps
    end
  end
end
