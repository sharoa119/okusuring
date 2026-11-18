# frozen_string_literal: true

class Announcement < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true
  validates :category, presence: true
  validates :category, inclusion: { in: %w[新機能 改善・修正 その他] }

  scope :published, -> { where.not(published_at: nil).where(published_at: ..Time.current) }
end
