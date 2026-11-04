# frozen_string_literal: true

class MedicationTime < ApplicationRecord
  belongs_to :medication_schedule
  has_many :medication_records, dependent: :destroy

  def taken_on?(date)
    medication_records.exists?(taken_date: date)
  end

  def taken_today?
    taken_on?(Date.current)
  end
end
