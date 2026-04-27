class MedicationSchedulesController < ApplicationController
  def new
    @medication_schedule = MedicationSchedule.new
    @medication_schedule.medication_times.build
  end

  def create
    @medication_schedule = current_user.medication_schedules.build(medication_schedule_params)

    if @medication_schedule.save
      redirect_to root_path, notice: '登録しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def medication_schedule_params
    params.require(:medication_schedule)
          .permit(:title, :target_name, :memo, medication_times_attributes: [:id, :time, :_destroy])
  end
end
