class User < ApplicationRecord
  has_many :medication_schedules, dependent: :destroy
  has_many :medication_times, through: :medication_schedules
  has_many :medication_records, through: :medication_times
end
