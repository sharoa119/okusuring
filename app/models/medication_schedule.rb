# frozen_string_literal: true

class MedicationSchedule < ApplicationRecord
  belongs_to :user
  has_many :medication_times, dependent: :destroy
  has_many :medication_records, through: :medication_times

  accepts_nested_attributes_for :medication_times, allow_destroy: true

  def viewable_by?(viewer)
    viewer == user || shared_with?(viewer)
  end

  private

  def shared_with?(viewer)
    FamilyLink.exists?(
      owner_user: user,
      member_user: viewer,
      status: 'accepted'
    ) || FamilyLink.exists?(
      owner_user: viewer,
      member_user: user,
      status: 'accepted'
    )
  end
end
