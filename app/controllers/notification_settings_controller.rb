# frozen_string_literal: true

class NotificationSettingsController < ApplicationController
  def show
  end

  def update
    if current_user.update(notification_setting_params)
      redirect_to notification_settings_path, notice: "通知設定を更新しました"
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def notification_setting_params
    params.require(:user).permit(:reminder_enabled, :reminder_interval)
  end
end
