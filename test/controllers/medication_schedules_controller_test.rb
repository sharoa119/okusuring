# frozen_string_literal: true

require 'test_helper'

class MedicationSchedulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_omniauth
  end

  teardown do
    teardown_omniauth
  end

  test 'ログイン済みの場合は新規登録画面が表示される' do
    user = users(:owner)

    log_in_as(user)

    get new_medication_schedule_path

    assert_response :success
    assert_match 'タイトル', response.body
    assert_match '飲む時間', response.body
  end

  test 'お薬予定を登録できる' do
    user = users(:owner)

    log_in_as(user)

    assert_difference('MedicationSchedule.count', 1) do
      post medication_schedules_path, params: {
        medication_schedule: {
          title: '風邪薬',
          target_name: '自分',
          memo: '食後に飲む',
          medication_times_attributes: {
            '0' => {
              time: '2025-01-01 09:00:00'
            }
          }
        }
      }
    end

    assert_redirected_to root_path
  end

  test '自分のお薬の予定を閲覧できる' do
    user = users(:owner)
    schedule = medication_schedules(:owner_schedule)

    log_in_as(user)

    get medication_schedule_path(schedule)

    assert_response :success
    assert_match '血圧の薬', response.body
  end

  test '家族共有されたお薬の予定を閲覧できる' do
    user = users(:member)
    schedule = medication_schedules(:owner_schedule)

    log_in_as(user)

    get medication_schedule_path(schedule)

    assert_response :success
    assert_match '血圧の薬', response.body
    assert_match '閲覧専用です', response.body
  end

  test '家族共有されていないお薬の予定は閲覧できない' do
    user = users(:not_family_member)
    schedule = medication_schedules(:owner_schedule)

    log_in_as(user)

    get medication_schedule_path(schedule)

    assert_redirected_to root_path
  end

  test '自分のお薬の予定を編集して更新できる' do
    user = users(:owner)
    schedule = medication_schedules(:owner_schedule)

    log_in_as(user)

    patch medication_schedule_path(schedule), params: {
      medication_schedule: {
        title: '血圧の薬（変更後）',
        target_name: '自分',
        memo: '夕食後に飲む',
        medication_times_attributes: {
          '0' => {
            id: medication_times(:morning_time).id,
            time: '2025-01-01 10:00:00'
          }
        }
      }
    }

    assert_redirected_to medication_schedule_path(schedule)

    schedule.reload
    assert_equal '血圧の薬（変更後）', schedule.title
    assert_equal '夕食後に飲む', schedule.memo
  end

  test '自分のお薬の予定を削除できる' do
    user = users(:owner)
    schedule = medication_schedules(:owner_schedule)

    log_in_as(user)

    assert_difference('MedicationSchedule.count', -1) do
      delete medication_schedule_path(schedule)
    end

    assert_redirected_to root_path
  end
end
