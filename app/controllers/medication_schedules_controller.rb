# frozen_string_literal: true

class MedicationSchedulesController < ApplicationController
  before_action :require_login

  def show
    @medication_schedule = MedicationSchedule.find(params[:id])

    unless @medication_schedule.viewable_by?(current_user)
      redirect_to root_path, alert: 'この予定は閲覧できません'
      return
    end

    @readonly = @medication_schedule.user != current_user
  end

  def new
    @medication_schedule = MedicationSchedule.new
    @medication_schedule.medication_times.build
  end

  def edit
    @medication_schedule = current_user.medication_schedules.find(params[:id])
  end

  def create
    @medication_schedule = current_user.medication_schedules.build(medication_schedule_params)

    if @medication_schedule.save
      redirect_to root_path, notice: '登録しました'
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    @medication_schedule = current_user.medication_schedules.find(params[:id])

    if @medication_schedule.update(medication_schedule_params)
      redirect_to @medication_schedule, notice: '更新しました'
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @medication_schedule =
      current_user.medication_schedules.find(params[:id])

    @medication_schedule.destroy

    redirect_to root_path, notice: '削除しました'
  end

  private

  def medication_schedule_params
    params.require(:medication_schedule)
          .permit(:title, :target_name, :memo, :reminder_interval, :reminder_enabled, medication_times_attributes: %i[
                    id time _destroy
                  ])
  end
end
