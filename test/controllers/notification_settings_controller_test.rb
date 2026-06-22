# frozen_string_literal: true

require "test_helper"

class NotificationSettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    OmniAuth.config.test_mode = true
  end

  teardown do
    OmniAuth.config.test_mode = false
    OmniAuth.config.mock_auth[:line] = nil
  end

  test "ログイン済みの場合は通知設定ページが表示される" do
    user = users(:owner)

    log_in_as(user)

    get notification_settings_url

    assert_response :success
    assert_match "通知設定", response.body
    assert_match "再通知", response.body
  end

  private

  def log_in_as(user)
    OmniAuth.config.mock_auth[:line] = OmniAuth::AuthHash.new(
      provider: "line",
      uid: user.line_user_id,
      info: { name: user.name }
    )

    get "/auth/line/callback"
  end
end
