class HomeController < ApplicationController
  # def index
  #   @today_schedules = MedicationSchedule.for_today
  #   @today_records   = MedicationRecord.where(taken_on: Date.current)

  #   @schedule_statuses = @today_schedules.map do |schedule|
  #     record = @today_records.find { |r| r.medication_schedule_id == schedule.id }

  #     {
  #       schedule: schedule,
  #       taken: record.present?
  #     }
  #   end
  # end
  def index
    user = User.find_by(line_user_id: 'test_user_1')
    @today_times = user.medication_times
                     .includes(:medication_schedule, :medication_records)
                     .order(:time)
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
          .permit(:title, :target_name, :memo, medication_times_attributes: [:id, :time, :_destroy])
  end
end
