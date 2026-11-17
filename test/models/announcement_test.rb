# frozen_string_literal: true

require 'test_helper'

class AnnouncementTest < ActiveSupport::TestCase
  test '有効な属性があれば保存できる' do
    announcement = Announcement.new(
      title: '服薬履歴機能を追加しました',
      body: '過去7日間の服薬状況を確認できるようになりました。',
      category: '新機能'
    )

    assert announcement.valid?
  end

  test 'タイトル・本文・カテゴリーは必須' do
    announcement = Announcement.new(
      title: nil,
      body: nil,
      category: nil
    )

    assert_not announcement.valid?
    assert_includes announcement.errors.attribute_names, :title
    assert_includes announcement.errors.attribute_names, :body
    assert_includes announcement.errors.attribute_names, :category
  end

  test '公開済みのお知らせだけを取得できる' do
    published = Announcement.create!(
      title: '公開済み',
      body: '公開中のお知らせです。',
      category: '新機能',
      published_at: 1.day.ago
    )

    Announcement.create!(
      title: '下書き',
      body: 'まだ公開していません。',
      category: '新機能',
      published_at: nil
    )

    Announcement.create!(
      title: '公開予約',
      body: '未来に公開するお知らせです。',
      category: '改善・修正',
      published_at: 1.day.from_now
    )

    announcements = Announcement.published

    assert_includes announcements, published
    assert_not_includes announcements, Announcement.find_by!(title: '下書き')
    assert_not_includes announcements, Announcement.find_by!(title: '公開予約')
  end
end
