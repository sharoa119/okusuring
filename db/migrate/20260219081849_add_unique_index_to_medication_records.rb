# frozen_string_literal: true

class AddUniqueIndexToMedicationRecords < ActiveRecord::Migration[7.1]
  def change
    add_index :medication_records,
              %i[medication_time_id taken_date],
              unique: true,
              name: 'index_medication_records_on_time_and_date'
  end
end
