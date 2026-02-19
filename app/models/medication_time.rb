class MedicationTime < ApplicationRecord
  belongs_to :medication_schedule
  has_many :medication_records, dependent: :destroy

  # 今日飲んだか？
  def taken_today?
    medication_records.any? { |r| r.taken_date == Date.current }
  end
end
