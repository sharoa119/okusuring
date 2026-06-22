# frozen_string_literal: true

require "test_helper"

class NotificationSettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_omniauth
  end

  teardown do
    teardown_omniauth
  end

  test "ログイン済みの場合は通知設定ページが表示される" do
    user = users(:owner)

    log_in_as(user)

    get notification_settings_url

    assert_response :success
    assert_match "通知設定", response.body
    assert_match "再通知", response.body
  end

  test "通知設定を更新できる" do
    user = users(:owner)

    log_in_as(user)

    patch notification_settings_url, params: {
      user: {
        reminder_enabled: false,
        reminder_interval: 15
      }
    }

    assert_redirected_to notification_settings_path

    user.reload
    assert_equal false, user.reminder_enabled
    assert_equal 15, user.reminder_interval
  end
end
