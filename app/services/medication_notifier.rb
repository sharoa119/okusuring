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

      user = medication_time.medication_schedule.user
      next unless user.line_bot_connected?

      if medication_time.time.change(sec: 0) == current_time
        message = "💊 #{medication_schedule.title} の時間です！"
      else
        message = "💊 #{medication_schedule.title} の[飲んだよ]が確認できません。お薬は飲まれましたか？"
      end

      LineBotClient.push_text(user.line_user_id, message)
    end
  end
end
