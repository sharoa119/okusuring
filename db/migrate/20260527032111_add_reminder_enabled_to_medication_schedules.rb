class AddReminderEnabledToMedicationSchedules < ActiveRecord::Migration[7.1]
  def change
    add_column :medication_schedules, :reminder_enabled, :boolean, default: true, null: false
  end
end
