class MedicationSchedule < ApplicationRecord
  belongs_to :user
  has_many :medication_times, dependent: :destroy

  accepts_nested_attributes_for :medication_times, allow_destroy: true
end
