class CreateMoods < ActiveRecord::Migration[7.1]
  def change
    create_table :moods do |t|
      t.references :record, null: false, foreign_key: true, index: { unique: true }
      t.integer :rating, null: false
      t.string :comment

      t.timestamps
    end
  end
end
