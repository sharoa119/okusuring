# frozen_string_literal: true

owner = User.find_or_create_by!(line_user_id: 'dev_owner') do |user|
  user.name = '本人ユーザー'
  user.line_bot_connected = true
  user.reminder_enabled = true
  user.reminder_interval = 10
end

family = User.find_or_create_by!(line_user_id: 'dev_family') do |user|
  user.name = '家族ユーザー'
  user.line_bot_connected = true
  user.reminder_enabled = true
  user.reminder_interval = 10
end

User.find_or_create_by!(line_user_id: 'dev_empty') do |user|
  user.name = '予定なしユーザー'
  user.line_bot_connected = true
  user.reminder_enabled = true
  user.reminder_interval = 10
end

User.find_or_create_by!(line_user_id: 'dev_bot_unlinked') do |user|
  user.name = 'BOT未連携ユーザー'
  user.line_bot_connected = false
  user.reminder_enabled = true
  user.reminder_interval = 10
end

User.find_or_create_by!(line_user_id: 'dev_invitee') do |user|
  user.name = '招待確認ユーザー'
  user.line_bot_connected = true
  user.reminder_enabled = true
  user.reminder_interval = 10
end

self_schedule = owner.medication_schedules.find_or_create_by!(
  title: '朝と夜の薬',
  target_name: '自分'
) do |schedule|
  schedule.memo = 'レビュー確認用の服薬予定です。'
end

child_schedule = owner.medication_schedules.find_or_create_by!(
  title: '子どもの朝の薬',
  target_name: '子ども'
) do |schedule|
  schedule.memo = '家族共有表示の確認用です。'
end

self_schedule.medication_times.destroy_all
child_schedule.medication_times.destroy_all

self_schedule.medication_times.create!(time: Time.zone.parse('08:00'))
self_schedule.medication_times.create!(time: Time.zone.parse('20:00'))
child_schedule.medication_times.create!(time: Time.zone.parse('07:30'))

owner.owned_family_links.find_or_create_by!(
  member_user: family
) do |family_link|
  family_link.status = 'accepted'
  family_link.token = 'dev_family_link_token'
end

pending_family_link = owner.owned_family_links.find_or_create_by!(
  token: 'dev_pending_invite_token'
)

pending_family_link.update!(
  member_user: nil,
  status: 'pending'
)
