class AddSleepTimeAndWakeTimeToRecordValues < ActiveRecord::Migration[7.1]
  def change
    add_column :record_values, :sleep_time, :time
    add_column :record_values, :wake_time, :time
  end
end
