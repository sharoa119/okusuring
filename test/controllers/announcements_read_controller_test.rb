# frozen_string_literal: true

require 'test_helper'

class AnnouncementsReadControllerTest < ActionDispatch::IntegrationTest
  setup do
    setup_omniauth
    @user = users(:owner)
  end

  teardown do
    teardown_omniauth
  end

  test 'お知らせ一覧を開いただけでは既読にならない' do
    log_in_as(@user)

    assert_no_difference('AnnouncementRead.count') do
      get announcements_path
    end

    assert_response :success
    assert_select '.page-container .announcement-new', count: Announcement.published.count
  end

  test 'お知らせ詳細を開くと既読になる' do
    log_in_as(@user)
    announcement = announcements(:one)

    assert_difference('AnnouncementRead.count', 1) do
      get announcement_path(announcement)
    end

    assert @user.announcement_reads.exists?(announcement: announcement)
  end

  test '同じお知らせを2回開いても既読は1件のまま' do
    log_in_as(@user)
    announcement = announcements(:one)

    get announcement_path(announcement)

    assert_no_difference('AnnouncementRead.count') do
      get announcement_path(announcement)
    end
  end

  test '既読にしたお知らせは一覧で未読表示されない' do
    log_in_as(@user)
    get announcement_path(announcements(:one))

    get announcements_path

    assert_select '.page-container .announcement-new', count: Announcement.published.count - 1
  end

  test '他のユーザーが既読にしても自分は未読のまま' do
    other = users(:member)
    other.announcement_reads.create!(announcement: announcements(:one))
    log_in_as(@user)

    get announcements_path

    assert_select '.page-container .announcement-new', count: Announcement.published.count
  end

  test '未読があるとメニューに赤い点とNEWが表示される' do
    log_in_as(@user)

    get announcements_path

    assert_select '.menu-new-dot', count: 1
    assert_select '.hamburger-menu .announcement-new', text: 'NEW'
  end

  test 'すべて読むとメニューの赤い点とNEWが消える' do
    log_in_as(@user)
    Announcement.published.find_each { |announcement| get announcement_path(announcement) }

    get announcements_path

    assert_select '.menu-new-dot', count: 0
    assert_select '.hamburger-menu .announcement-new', count: 0
  end

  test '一覧のお知らせリンクは先読みされない' do
    log_in_as(@user)

    get announcements_path

    assert_select "a[href='#{announcement_path(announcements(:one))}'][data-turbo-prefetch='false']"
  end

  test '管理者が下書きを開いても既読にならない' do
    @user.update!(admin: true)
    log_in_as(@user)
    draft = Announcement.create!(
      title: '下書き',
      body: 'まだ公開していません。',
      category: '新機能',
      published_at: nil
    )

    assert_no_difference('AnnouncementRead.count') do
      get announcement_path(draft)
    end

    assert_response :success
  end
end
