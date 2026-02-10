class MedicationTime < ApplicationRecord
  belongs_to :medication_schedule
  has_many :medication_records, dependent: :destroy
end
