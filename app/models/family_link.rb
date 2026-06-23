# frozen_string_literal: true

class FamilyLink < ApplicationRecord
  belongs_to :owner_user, class_name: 'User'
  belongs_to :member_user, class_name: 'User', optional: true
end
