# frozen_string_literal: true

require 'test_helper'

class AnnouncementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_omniauth
  end

  teardown do
    teardown_omniauth
  end

  test 'ログイン済みの場合はお知らせ一覧が表示される' do
    user = users(:owner)
    log_in_as(user)

    get announcements_path

    assert_response :success
  end

  test 'ログイン済みの場合は公開済みのお知らせ詳細が表示される' do
    user = users(:owner)
    log_in_as(user)
    announcement = announcements(:one)

    get announcement_path(announcement)

    assert_response :success
    assert_select 'h3', text: announcement.title
  end

  test '未ログインの場合はお知らせ一覧からログイン画面へ移動する' do
    get announcements_path

    assert_redirected_to root_path
  end

  test '未ログインの場合はお知らせ詳細からログイン画面へ移動する' do
    announcement = announcements(:one)

    get announcement_path(announcement)

    assert_redirected_to root_path
  end

  test '下書きのお知らせは詳細を表示できない' do
    user = users(:owner)
    log_in_as(user)

    announcement = Announcement.create!(
      title: '下書き',
      body: 'まだ公開していません。',
      category: '新機能',
      published_at: nil
    )

    get announcement_path(announcement)

    assert_response :not_found
  end

  test '公開予約のお知らせは詳細を表示できない' do
    user = users(:owner)
    log_in_as(user)

    announcement = Announcement.create!(
      title: '公開予約',
      body: '未来に公開するお知らせです。',
      category: '改善・修正',
      published_at: 1.day.from_now
    )

    get announcement_path(announcement)

    assert_response :not_found
  end
end
