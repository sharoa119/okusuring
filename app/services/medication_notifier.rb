# frozen_string_literal: true

class MedicationNotifier
  def self.notify_now
    current_time = Time.current.change(sec: 0)

    medication_times = MedicationTime.where(time: current_time)

    medication_times.each do |medication_time|
      user = medication_time.medication_schedule.user

      next unless user.line_bot_connected?

      LineBotClient.push_text(
        user.line_user_id,
        "お薬の時間です！"
      )
    end
  end
end
