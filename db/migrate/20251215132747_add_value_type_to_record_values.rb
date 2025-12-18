class AddValueTypeToRecordValues < ActiveRecord::Migration[7.1]
  def change
    add_column :record_values, :value_type, :string
  end
end
