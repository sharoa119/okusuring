# frozen_string_literal: true

class MedicationHistoriesController < ApplicationController
  before_action :require_login

  def index
    @dates = (Date.current - 6.days)..Date.current
    @medication_times = current_user.medication_times.includes(:medication_records, :medication_schedule)
  end
end
