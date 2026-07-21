# frozen_string_literal: true

require 'test_helper'

class MedicationRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_omniauth
    @member = users(:member)
    @medication_time = medication_times(:member_time)
  end

  teardown do
    teardown_omniauth
  end

  test '未ログインでは今日の服薬記録を作成できない' do
    assert_no_difference('MedicationRecord.count') do
      post medication_time_medication_records_path(@medication_time)
    end

    assert_redirected_to root_path
  end

  test '飲んだよを押すと今日の服薬記録が作成される' do
    log_in_as(@member)

    assert_difference('MedicationRecord.count', 1) do
      post medication_time_medication_records_path(@medication_time)
    end

    assert_redirected_to root_path
  end

  test '同じ服薬時間の飲んだよ記録は1日に重複して作成されない' do
    log_in_as(@member)

    MedicationRecord.create!(
      medication_time: @medication_time,
      taken_date: Date.current
    )

    assert_no_difference('MedicationRecord.count') do
      post medication_time_medication_records_path(@medication_time)
    end

    assert_redirected_to root_path
  end

  test '他のユーザーの服薬時間には記録を作成できない' do
    log_in_as(users(:owner))

    assert_no_difference('MedicationRecord.count') do
      post medication_time_medication_records_path(@medication_time)
    end

    assert_response :not_found
  end

  test '自分の今日の服薬記録を取り消せる' do
    log_in_as(@member)

    record = MedicationRecord.create!(
      medication_time: @medication_time,
      taken_date: Date.current
    )

    assert_difference('MedicationRecord.count', -1) do
      delete medication_time_medication_record_path(@medication_time, record)
    end

    assert_redirected_to root_path
  end

  test '他のユーザーの服薬記録は取り消せない' do
    record = MedicationRecord.create!(
      medication_time: @medication_time,
      taken_date: Date.current
    )

    log_in_as(users(:owner))

    assert_no_difference('MedicationRecord.count') do
      delete medication_time_medication_record_path(@medication_time, record)
    end

    assert_response :not_found
  end
end
