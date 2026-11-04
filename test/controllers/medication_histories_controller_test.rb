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
end
