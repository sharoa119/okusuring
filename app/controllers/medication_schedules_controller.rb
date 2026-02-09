class MedicationSchedulesController < ApplicationController
  def index
    @medication_schedules = MedicationSchedule.all
  end
end
