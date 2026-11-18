# frozen_string_literal: true

require 'test_helper'

class AnnouncementsAdminAccessControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_omniauth
  end

  teardown do
    teardown_omniauth
  end

  test '管理者は下書きのお知らせ詳細を表示できる' do
    user = users(:owner)
    user.update!(admin: true)
    log_in_as(user)

    announcement = Announcement.create!(
      title: '管理者向け下書き',
      body: '公開前のお知らせです。',
      category: '新機能',
      published_at: nil
    )

    get announcement_path(announcement)

    assert_response :success
    assert_select 'h3', text: announcement.title
  end

  test '管理者は公開予約のお知らせ詳細を表示できる' do
    user = users(:owner)
    user.update!(admin: true)
    log_in_as(user)

    announcement = Announcement.create!(
      title: '管理者向け公開予約',
      body: '未来に公開するお知らせです。',
      category: '改善・修正',
      published_at: 1.day.from_now
    )

    get announcement_path(announcement)

    assert_response :success
    assert_select 'h3', text: announcement.title
  end

  test '管理者のお知らせ一覧には下書きと公開予約も表示される' do
    user = users(:owner)
    user.update!(admin: true)
    log_in_as(user)

    draft = Announcement.create!(
      title: '管理者用下書き',
      body: 'まだ公開していません。',
      category: '新機能',
      published_at: nil
    )

    scheduled = Announcement.create!(
      title: '管理者用公開予約',
      body: '未来に公開します。',
      category: '改善・修正',
      published_at: 1.day.from_now
    )

    get announcements_path

    assert_response :success
    assert_select 'a', text: draft.title
    assert_select 'a', text: scheduled.title
  end

  test '管理者はお知らせの新規作成画面を表示できる' do
    user = users(:owner)
    user.update!(admin: true)
    log_in_as(user)

    get new_announcement_path

    assert_response :success
    assert_select 'h1', text: 'お知らせを新規作成'
  end

  test '管理者はお知らせの編集画面を表示できる' do
    user = users(:owner)
    user.update!(admin: true)
    log_in_as(user)
    announcement = announcements(:one)

    get edit_announcement_path(announcement)

    assert_response :success
    assert_select 'h1', text: 'お知らせを編集'
  end
end
