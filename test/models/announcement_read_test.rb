# frozen_string_literal: true

require 'test_helper'

class AnnouncementReadTest < ActiveSupport::TestCase
  test '同じユーザーが同じお知らせを二重に既読登録できない' do
    user = users(:owner)
    announcement = announcements(:one)
    AnnouncementRead.create!(user: user, announcement: announcement)

    duplicate = AnnouncementRead.new(user: user, announcement: announcement)

    assert_not duplicate.valid?
  end

  test '公開済みの未読お知らせがあるかを判定できる（公開予約は対象外）' do
    user = users(:owner)
    Announcement.create!(title: '予約', body: '本文', category: 'その他', published_at: 1.day.from_now)

    assert user.unread_announcements?

    Announcement.published.find_each { |announcement| user.announcement_reads.create!(announcement: announcement) }

    assert_not user.unread_announcements?
  end

  test 'お知らせを削除すると既読レコードも削除される' do
    read = AnnouncementRead.create!(user: users(:owner), announcement: announcements(:one))

    announcements(:one).destroy

    assert_not AnnouncementRead.exists?(read.id)
  end
end
