class AddNotNullConstraintsToMedications < ActiveRecord::Migration[7.1]
  def change
    change_column_null :medication_schedules, :title, false
    change_column_null :medication_schedules, :target_name, false
    change_column_null :medication_times, :time, false
    change_column_null :medication_records, :taken_date, false
  end
end
