# frozen_string_literal: true

class MedicationNotifier
  def self.notify_now
    current_time = Time.current.change(sec: 0)

    medication_times = MedicationTime.all

    medication_times.each do |medication_time|
      medication_schedule = medication_time.medication_schedule
      reminder_time = medication_schedule.reminder_interval.minutes.ago.change(sec: 0)

      next unless [current_time, reminder_time].include?(medication_time.time.change(sec: 0))

      already_taken = medication_time.medication_records.exists?(taken_date: Date.current)
      next if already_taken

      initial_notification =
        medication_time.time.change(sec: 0) == current_time

      reminder_notification =
        medication_time.time.change(sec: 0) == reminder_time

      next if reminder_notification && !medication_schedule.reminder_enabled?

      user = medication_time.medication_schedule.user
      next unless user.line_bot_connected?

      if medication_time.time.change(sec: 0) == current_time
        message = "💊 #{medication_schedule.title} の時間です！\n飲んだらアプリで「飲んだよ」を押してください。\nhttp://localhost:3000"
      else
        message = "💊 #{medication_schedule.title} の[飲んだよ]が確認できません。お薬は飲まれましたか？"
      end

      LineBotClient.push_text(user.line_user_id, message)
      if reminder_notification
        family_links = FamilyLink.where(owner_user: user, status: "accepted")

        family_links.each do |link|
          family_user = link.member_user
          next unless family_user&.line_bot_connected?

          Rails.logger.info("家族通知: #{family_user.name} に送信")

          LineBotClient.push_text(
            family_user.line_user_id,
            "💊 #{user.name}さんの「#{medication_schedule.title}」の飲んだよが確認できません。声をかけてみてください。"
          )
        end
      end
    end
  end
end
