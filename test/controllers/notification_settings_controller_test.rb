require "test_helper"

class NotificationSettingsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get notification_settings_show_url
    assert_response :success
  end
end
