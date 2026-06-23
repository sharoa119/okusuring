# frozen_string_literal: true

class MedicationRecord < ApplicationRecord
  belongs_to :medication_time
end
