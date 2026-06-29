# frozen_string_literal: true

require 'test_helper'

class FamilyLinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_omniauth
  end

  teardown do
    teardown_omniauth
  end

  test '未ログインの招待相手が招待URLを開くとL-1が表示される' do
    family_link = family_links(:pending_link)

    get invite_path(family_link.token)

    assert_response :success
    assert_match '家族から招待が届いています', response.body
  end

  test 'BOT未連携の招待相手が招待URLを開くとL-2が表示される' do
    family_link = family_links(:pending_link)
    user = users(:bot_not_connected)

    log_in_as(user)

    get invite_path(family_link.token)

    assert_response :success
    assert_match '招待の確認ができました', response.body
  end

  test 'BOT連携済みの招待相手が招待URLを開くとL-3が表示され共有が完了する' do
    family_link = family_links(:pending_link)
    user = users(:another_member)

    log_in_as(user)

    get invite_path(family_link.token)

    assert_response :success
    assert_match '共有設定が完了しました', response.body

    family_link.reload
    assert_equal user, family_link.member_user
    assert_equal 'accepted', family_link.status
  end

  test 'オーナーが家族共有を解除できる' do
    family_link = family_links(:accepted_link)
    owner = family_link.owner_user

    log_in_as(owner)

    assert_difference('FamilyLink.count', -1) do
      delete family_link_path(family_link)
    end

    assert_redirected_to family_links_path
  end
end
