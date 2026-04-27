# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    if current_user
      @my_times = current_user.medication_times
                              .includes(:medication_schedule, :medication_records)
                              .order(:time)
    else
      @my_times = []
    end

    # 家族の予定（まだ未実装なので空配列）
    @family_times = []
  end
end
