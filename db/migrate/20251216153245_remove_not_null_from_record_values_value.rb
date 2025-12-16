class RemoveNotNullFromRecordValuesValue < ActiveRecord::Migration[7.1]
  def change
    change_column_null :record_values, :value, true
  end
end
