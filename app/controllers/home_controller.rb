# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    if current_user
      @my_times = current_user.medication_times
                              .includes(:medication_schedule, :medication_records)
                              .sort_by { |time| [time.time.hour, time.time.min] }

      @owned_family_links = current_user.owned_family_links

      owned_links = current_user.owned_family_links.where(status: 'accepted')
      joined_links = current_user.joined_family_links.where(status: 'accepted')

      family_users =
        owned_links.map(&:member_user).compact +
        joined_links.map(&:owner_user).compact

      @has_family_links = family_users.any?

      @family_times = MedicationTime.joins(:medication_schedule)
                                    .where(medication_schedules: { user_id: family_users.map(&:id) })
                                    .includes(:medication_schedule, :medication_records)
                                    .sort_by { |time| [time.time.hour, time.time.min] }
    else
      @my_times = []
      @owned_family_links = []
      @family_times = []
      @has_family_links = false
    end
  end
end
