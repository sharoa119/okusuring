# frozen_string_literal: true

class CreateMedicationSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :medication_schedules do |t|
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
