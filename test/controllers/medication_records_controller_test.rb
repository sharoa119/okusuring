# frozen_string_literal: true

require "test_helper"

class MedicationRecordsControllerTest < ActionDispatch::IntegrationTest
  test "飲んだよを押すと今日の服薬記録が作成される" do
    medication_time = medication_times(:member_time)

    assert_difference("MedicationRecord.count", 1) do
      post medication_time_medication_records_path(medication_time)
    end

    assert_redirected_to root_path
  end

  test "同じ服薬時間の飲んだよ記録は1日に重複して作成されない" do
    medication_time = medication_times(:member_time)

    MedicationRecord.create!(
      medication_time: medication_time,
      taken_date: Date.current
    )

    assert_no_difference("MedicationRecord.count") do
      post medication_time_medication_records_path(medication_time)
    end

    assert_redirected_to root_path
  end
end
