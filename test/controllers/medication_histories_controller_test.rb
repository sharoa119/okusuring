# frozen_string_literal: true

require 'test_helper'

class MedicationHistoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_omniauth
  end

  teardown do
    teardown_omniauth
  end

  test 'ログイン済みの場合は服薬履歴ページが表示される' do
    user = users(:owner)
    log_in_as(user)

    get medication_histories_path

    assert_response :success
  end

  test '今日の服薬予定時刻より前なら予定と表示される' do
    user = users(:owner)
    log_in_as(user)

    travel_to Time.zone.local(2026, 1, 3, 8, 0, 0) do
      get medication_histories_path

      assert_response :success
      assert_select '.med-status', text: '予定'
    end
  end

  test '今日の服薬予定時刻を過ぎていて記録がなければ未と表示される' do
    user = users(:owner)
    log_in_as(user)

    travel_to Time.zone.local(2026, 1, 3, 10, 0, 0) do
      get medication_histories_path

      assert_response :success
      assert_select '.med-status', text: '未'
    end
  end

  test '今日の服薬記録があれば済と表示される' do
    user = users(:owner)
    log_in_as(user)

    travel_to Time.zone.local(2026, 1, 1, 10, 0, 0) do
      get medication_histories_path

      assert_response :success
      assert_select '.med-status', text: '済'
    end
  end

  test '過去の日付で服薬記録がなければ未と表示される' do
    user = users(:owner)
    log_in_as(user)

    travel_to Time.zone.local(2026, 1, 4, 10, 0, 0) do
      get medication_histories_path

      assert_response :success
      assert_select '.med-status', text: '未'
    end
  end
end
