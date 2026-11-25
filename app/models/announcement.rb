# frozen_string_literal: true

class Announcement < ApplicationRecord
  has_many :announcement_reads, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true
  validates :category, presence: true
  validates :category, inclusion: { in: %w[新機能 改善・修正 その他] }

  scope :published, -> { where.not(published_at: nil).where(published_at: ..Time.current) }

  def published?
    published_at.present? && published_at <= Time.current
  end
end
