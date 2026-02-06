class CreateMedicationRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :medication_records do |t|
      t.references :medication_time, null: false, foreign_key: true

      t.timestamps
    end
  end
end
