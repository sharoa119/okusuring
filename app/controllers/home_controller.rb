# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    if current_user
      @my_times = current_user.medication_times
                              .includes(:medication_schedule, :medication_records)
                              .order(:time)

      @owned_family_links = current_user.owned_family_links

      accepted_links = current_user.owned_family_links.where(status: "accepted")
      family_users = accepted_links.map(&:member_user).compact

      @family_times = MedicationTime.joins(:medication_schedule)
                                    .where(medication_schedules: { user_id: family_users.map(&:id) })
                                    .includes(:medication_schedule, :medication_records)
                                    .order(:time)

      @has_family_links = current_user.owned_family_links.exists?
    else
      @my_times = []
      @owned_family_links = []
      @family_times = []
      @has_family_links = false
    end
  end
end
