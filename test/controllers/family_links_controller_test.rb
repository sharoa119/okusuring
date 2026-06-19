# frozen_string_literal: true

require "test_helper"

class FamilyLinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    OmniAuth.config.test_mode = true
  end

  teardown do
    OmniAuth.config.test_mode = false
    OmniAuth.config.mock_auth[:line] = nil
  end

  test "未ログインの招待相手が招待URLを開くとL-1が表示される" do
    family_link = family_links(:pending_link)

    get invite_path(family_link.token)

    assert_response :success
    assert_match "家族から招待が届いています", response.body
  end

  test "BOT未連携の招待相手が招待URLを開くとL-2が表示される" do
    family_link = family_links(:pending_link)
    user = users(:bot_not_connected)

    log_in_as(user)

    get invite_path(family_link.token)

    assert_response :success
    assert_match "招待の確認ができました", response.body
  end

  test "BOT連携済みの招待相手が招待URLを開くとL-3が表示され共有が完了する" do
    family_link = family_links(:pending_link)
    user = users(:another_member)

    log_in_as(user)

    get invite_path(family_link.token)

    assert_response :success
    assert_match "共有設定が完了しました", response.body

    family_link.reload
    assert_equal user, family_link.member_user
    assert_equal "accepted", family_link.status
  end

  private

  def log_in_as(user)
    OmniAuth.config.mock_auth[:line] = OmniAuth::AuthHash.new(
      provider: "line",
      uid: user.line_user_id,
      info: {
        name: user.name
      }
    )

    get "/auth/line/callback"
  end
end
