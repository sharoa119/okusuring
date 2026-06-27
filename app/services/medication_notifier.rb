# frozen_string_literal: true

class MedicationNotifier
  CHECK_RANGE = 5.minutes

  def self.notify_now
    MedicationTime.find_each do |medication_time|
      new(medication_time).notify
    end
  end

  def initialize(medication_time)
    @medication_time = medication_time
    @medication_schedule = medication_time.medication_schedule
    @user = @medication_schedule.user
    @current_time = Time.current.change(sec: 0)
    @check_start_time = CHECK_RANGE.ago.change(sec: 0)
  end

  def notify
    return unless notification_target?
    return if already_taken?
    return if reminder_notification? && !@user.reminder_enabled?
    return unless @user.line_bot_connected?

    LineBotClient.push_text(@user.line_user_id, message)
    notify_family if reminder_notification?
  end

  private

  def notification_target?
    first_notification? || reminder_notification?
  end

  def first_notification?
    scheduled_time.between?(@check_start_time, @current_time)
  end

  def reminder_notification?
    reminder_time.between?(@check_start_time, @current_time)
  end

  def scheduled_time
    Time.current.change(
      hour: @medication_time.time.hour,
      min: @medication_time.time.min,
      sec: 0
    )
  end

  def reminder_time
    scheduled_time + @user.reminder_interval.minutes
  end

  def already_taken?
    @medication_time.medication_records.exists?(taken_date: Date.current)
  end

  def message
    if reminder_notification?
      "💊 #{@medication_schedule.title} の[飲んだよ]が確認できません。お薬は飲まれましたか？"
    else
      "💊 #{@medication_schedule.title} の時間です！\n飲んだらアプリで「飲んだよ」を押してください。\n#{ENV.fetch('APP_URL', nil)}"
    end
  end

  def notify_family
    family_links.find_each do |link|
      family_user = link.member_user
      next unless family_user&.line_bot_connected?

      Rails.logger.info("家族通知: #{family_user.name} に送信")

      LineBotClient.push_text(
        family_user.line_user_id,
        "💊 #{@user.name}さんの「#{@medication_schedule.title}」の飲んだよが確認できません。声をかけてみてください。"
      )
    end
  end

  def family_links
    FamilyLink.where(owner_user: @user, status: 'accepted')
  end
end
