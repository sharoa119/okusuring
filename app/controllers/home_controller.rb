# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    today_wday = Date.current.wday

    @today_times = current_user.medication_times
                               .includes(:medication_schedule, :medication_records)
                               .order(:time)
  end
end
