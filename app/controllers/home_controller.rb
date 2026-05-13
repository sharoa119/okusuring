# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    # 自分の予定
    @my_times = current_user.medication_times
                            .includes(:medication_schedule, :medication_records)
                            .order(:time)

    # 家族の予定（まだ未実装なので空配列）
    @family_times = []
  end
end
