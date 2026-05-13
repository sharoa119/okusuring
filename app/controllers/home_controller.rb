# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    if current_user
      @my_times = current_user.medication_times
                              .includes(:medication_schedule, :medication_records)
                              .order(:time)

      @owned_family_links = current_user.owned_family_links
    else
      @my_times = []
      @owned_family_links = []
    end

    # 家族の予定（まだ未実装なので空配列）
    @family_times = []

    # 家族共有しているかどうか
    @has_family_links = current_user.present? && current_user.owned_family_links.exists?
  end
end
