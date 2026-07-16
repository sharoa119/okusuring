# frozen_string_literal: true

class MedicationRecordsController < ApplicationController
  def create
    medication_time = MedicationTime.find(params[:medication_time_id])

    unless medication_time.taken_today?
      medication_time.medication_records.create!(
        taken_date: Date.current
      )
    end

    redirect_to root_path, notice: '「飲んだよ」を記録しました'
  end

  def destroy
    medication_time = MedicationTime.find(params[:medication_time_id])
    medication_time.medication_records.where(taken_date: Date.current).destroy_all

    redirect_to root_path, notice: '記録を取り消しました'
  end
end
