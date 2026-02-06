class CreateMedicationTimes < ActiveRecord::Migration[7.1]
  def change
    create_table :medication_times do |t|
      t.references :medication_schedule, null: false, foreign_key: true

      t.timestamps
    end
  end
end
