class AddTakenDateToMedicationRecords < ActiveRecord::Migration[7.1]
  def change
    add_column :medication_records, :taken_date, :date
  end
end
