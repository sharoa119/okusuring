class MedicationSchedule < ApplicationRecord
  belongs_to :user
  has_many :medication_times, dependent: :destroy
  has_many :medication_records, through: :medication_times

  accepts_nested_attributes_for :medication_times, allow_destroy: true
end
