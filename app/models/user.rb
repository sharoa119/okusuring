# frozen_string_literal: true

class User < ApplicationRecord
  has_many :medication_schedules, dependent: :destroy
  has_many :medication_times, through: :medication_schedules
  has_many :medication_records, through: :medication_times

  has_many :announcement_reads, dependent: :destroy
  has_many :read_announcements, through: :announcement_reads, source: :announcement

  has_many :owned_family_links,
           class_name: 'FamilyLink',
           foreign_key: :owner_user_id,
           inverse_of: :owner_user,
           dependent: :destroy

  has_many :joined_family_links,
           class_name: 'FamilyLink',
           foreign_key: :member_user_id,
           inverse_of: :member_user,
           dependent: :nullify

  def unread_announcements?
    Announcement.published.where.not(id: announcement_reads.select(:announcement_id)).exists?
  end

  def shared_with?(viewer)
    owned_family_links.accepted.exists?(member_user: viewer) ||
      joined_family_links.accepted.exists?(owner_user: viewer)
  end
end
