class AddTimeToMedicationTimes < ActiveRecord::Migration[7.1]
  def change
    add_column :medication_times, :time, :datetime
  end
end
