# frozen_string_literal: true

require 'test_helper'

class AnnouncementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_omniauth
  end

  teardown do
    teardown_omniauth
  end

  test '一般ユーザーはお知らせを新規作成できない' do
    user = users(:owner)
    log_in_as(user)

    assert_no_difference('Announcement.count') do
      post announcements_path, params: {
        announcement: {
          title: '不正なお知らせ',
          body: '一般ユーザーからの投稿です。',
          category: '新機能',
          published_at: Time.current
        }
      }
    end

    assert_redirected_to root_path
  end

  test '一般ユーザーはお知らせの新規作成画面を表示できない' do
    user = users(:owner)
    log_in_as(user)

    get new_announcement_path

    assert_redirected_to root_path
  end

  test '一般ユーザーはお知らせの編集画面を表示できない' do
    user = users(:owner)
    log_in_as(user)
    announcement = announcements(:one)

    get edit_announcement_path(announcement)

    assert_redirected_to root_path
  end

  test '一般ユーザーはお知らせを更新できない' do
    user = users(:owner)
    log_in_as(user)
    announcement = announcements(:one)
    original_title = announcement.title

    patch announcement_path(announcement), params: {
      announcement: {
        title: '不正なタイトル'
      }
    }

    assert_redirected_to root_path
    assert_equal original_title, announcement.reload.title
  end

  test '一般ユーザーはお知らせを削除できない' do
    user = users(:owner)
    log_in_as(user)
    announcement = announcements(:one)

    assert_no_difference('Announcement.count') do
      delete announcement_path(announcement)
    end

    assert_redirected_to root_path
  end
end
