# frozen_string_literal: true

require "test_helper"

class MedicationSchedulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    OmniAuth.config.test_mode = true
  end

  teardown do
    OmniAuth.config.test_mode = false
    OmniAuth.config.mock_auth[:line] = nil
  end

  test "ログイン済みの場合は新規登録画面が表示される" do
    user = users(:owner)

    log_in_as(user)

    get new_medication_schedule_path

    assert_response :success
    assert_match "タイトル", response.body
    assert_match "飲む時間", response.body
  end

  test "お薬予定を登録できる" do
    user = users(:owner)

    log_in_as(user)

    assert_difference("MedicationSchedule.count", 1) do
      post medication_schedules_path, params: {
        medication_schedule: {
          title: "風邪薬",
          target_name: "自分",
          memo: "食後に飲む",
          medication_times_attributes: {
            "0" => {
              time: "2025-01-01 09:00:00"
            }
          }
        }
      }
    end

    assert_redirected_to root_path
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
