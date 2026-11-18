# frozen_string_literal: true

require 'test_helper'

class AnnouncementsAdminControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_omniauth
  end

  teardown do
    teardown_omniauth
  end

  test '管理者はお知らせを新規作成できる' do
    user = users(:owner)
    user.update!(admin: true)
    log_in_as(user)

    assert_difference('Announcement.count', 1) do
      post announcements_path, params: {
        announcement: {
          title: 'テストのお知らせ',
          body: '管理者が作成したお知らせです。',
          category: '新機能',
          published_at: Time.current
        }
      }
    end

    assert_redirected_to announcements_path
    assert_equal 'テストのお知らせ', Announcement.last.title
  end

  test '管理者はお知らせを更新できる' do
    user = users(:owner)
    user.update!(admin: true)
    log_in_as(user)
    announcement = announcements(:one)

    patch announcement_path(announcement), params: {
      announcement: {
        title: '更新後のお知らせ'
      }
    }

    assert_redirected_to announcement_path(announcement)
    assert_equal '更新後のお知らせ', announcement.reload.title
  end

  test '管理者はお知らせを削除できる' do
    user = users(:owner)
    user.update!(admin: true)
    log_in_as(user)
    announcement = announcements(:one)

    assert_difference('Announcement.count', -1) do
      delete announcement_path(announcement)
    end

    assert_redirected_to announcements_path
  end

  test '管理者はタイトルが空欄のお知らせを作成できない' do
    user = users(:owner)
    user.update!(admin: true)
    log_in_as(user)

    assert_no_difference('Announcement.count') do
      post announcements_path, params: {
        announcement: {
          title: '',
          body: '本文があります。',
          category: '新機能',
          published_at: Time.current
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select 'h1', text: 'お知らせを新規作成'
  end

  test '管理者はタイトルが空欄のお知らせに更新できない' do
    user = users(:owner)
    user.update!(admin: true)
    log_in_as(user)
    announcement = announcements(:one)
    original_title = announcement.title

    patch announcement_path(announcement), params: {
      announcement: {
        title: ''
      }
    }

    assert_response :unprocessable_entity
    assert_select 'h1', text: 'お知らせを編集'
    assert_equal original_title, announcement.reload.title
  end
end
