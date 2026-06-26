# frozen_string_literal: true

class MedicationTime < ApplicationRecord
  belongs_to :medication_schedule
  has_many :medication_records, dependent: :destroy

  def taken_today?
    medication_records.any? { |r| r.taken_date == Date.current }
  end
end
