class User < ApplicationRecord
  has_many :medication_schedules, dependent: :destroy
end
