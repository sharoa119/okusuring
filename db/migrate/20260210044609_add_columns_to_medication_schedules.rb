# frozen_string_literal: true

class AddColumnsToMedicationSchedules < ActiveRecord::Migration[7.1]
  def change
    add_column :medication_schedules, :title, :string
    add_column :medication_schedules, :target_name, :string
  end
end
