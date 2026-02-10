class MedicationSchedule < ApplicationRecord
  belongs_to :user
  has_many :medication_times, dependent: :destroy
end
