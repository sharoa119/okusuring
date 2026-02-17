class MedicationSchedulesController < ApplicationController
  def index
    user = User.find_by(line_user_id: 'test_user_1')
    @schedules = user.medication_schedules.includes(:medication_times)
  end

  def new
    @medication_schedule = MedicationSchedule.new
    @medication_schedule.medication_times.build
  end

  def create
    user = User.find_by(line_user_id: 'test_user_1')
    @medication_schedule = user.medication_schedules.build(medication_schedule_params)

    if @medication_schedule.save
      redirect_to medication_schedules_path, notice: '登録しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def medication_schedule_params
    params.require(:medication_schedule)
          .permit(:title, :target_name, medication_times_attributes: [:id, :time, :_destroy])
  end
end
