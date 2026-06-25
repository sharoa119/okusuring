# frozen_string_literal: true

class NotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    return head :unauthorized unless request.headers['X-Notify-Token'] == ENV['NOTIFY_TOKEN']

    MedicationNotifier.notify_now
    head :ok
  end
end
