# frozen_string_literal: true

class MedicationRecordsController < ApplicationController
  before_action :require_login
  before_action :set_medication_time

  def create
    unless @medication_time.taken_today?
      @medication_time.medication_records.create!(
        taken_date: Date.current
      )
    end

    redirect_to root_path, notice: '「飲んだよ」を記録しました'
  end

  def destroy
    @medication_time.medication_records
                    .where(taken_date: Date.current)
                    .destroy_all

    redirect_to root_path, notice: '記録を取り消しました'
  end

  private

  def set_medication_time
    @medication_time = current_user.medication_times.find(params[:medication_time_id])
  end
end
