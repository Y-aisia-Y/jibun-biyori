class AddNullConstraintToRecordValuesValue < ActiveRecord::Migration[7.1]
  def change
    change_column_null :record_values, :value, false
  end
end
