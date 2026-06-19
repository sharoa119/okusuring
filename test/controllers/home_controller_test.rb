# frozen_string_literal: true

require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    OmniAuth.config.test_mode = true
  end

  teardown do
    OmniAuth.config.test_mode = false
    OmniAuth.config.mock_auth[:line] = nil
  end

  test "未ログイン時はログイン前トップが表示される" do
    get root_path

    assert_response :success
    assert_match "LINEでログイン", response.body
    assert_match "おくすリングは", response.body
  end

  test "ログイン済みの場合は今日のお薬の予定が表示される" do
    user = users(:owner)

    log_in_as(user)

    get root_path

    assert_response :success
    assert_match "今日のお薬の予定", response.body
    assert_match "自分の予定", response.body
    assert_match "血圧の薬", response.body
  end

  test "予定がない場合は今日の服薬予定はありませんが表示される" do
    user = users(:no_schedule_user)

    log_in_as(user)

    get root_path

    assert_response :success
    assert_match "今日の服薬予定はありません", response.body
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
