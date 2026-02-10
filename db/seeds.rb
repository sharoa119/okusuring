# frozen_string_literal: true

user = User.find_or_create_by!(line_user_id: 'test_user_1')

self_schedule = user.medication_schedules.find_or_create_by!(
  title: '朝と夜の薬',
  target_name: '自分'
)

child_schedule = user.medication_schedules.find_or_create_by!(
  title: '朝の薬',
  target_name: '子ども'
)

self_schedule.medication_times.find_or_create_by!(
  time: Time.zone.parse('08:00')
)

self_schedule.medication_times.find_or_create_by!(
  time: Time.zone.parse('20:00')
)

child_schedule.medication_times.find_or_create_by!(
  time: Time.zone.parse('07:30')
)
