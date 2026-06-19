# frozen_string_literal: true

require "test_helper"

class MedicationTimeTest < ActiveSupport::TestCase
  test "今日の服薬記録がある場合はtaken_today?がtrueになる" do
    medication_time = medication_times(:morning_time)

    MedicationRecord.create!(
      medication_time: medication_time,
      taken_date: Date.current
    )

    assert medication_time.taken_today?
  end

  test "今日の服薬記録がない場合はtaken_today?がfalseになる" do
    medication_time = medication_times(:member_time)

    assert_not medication_time.taken_today?
  end
end
