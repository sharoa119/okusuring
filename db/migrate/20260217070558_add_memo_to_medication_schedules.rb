# frozen_string_literal: true

class AddMemoToMedicationSchedules < ActiveRecord::Migration[7.1]
  def change
    add_column :medication_schedules, :memo, :text
  end
end
