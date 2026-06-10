class AddReminderIntervalToMedicationSchedules < ActiveRecord::Migration[7.1]
  def change
    add_column :medication_schedules, :reminder_interval, :integer, default: 5, null: false
  end
end
