class MedicationSchedulesController < ApplicationController
  def index
    user = User.find_by(line_user_id: 'test_user_1')

    @schedules = user.medication_schedules
                     .includes(:medication_times)
  end
end
