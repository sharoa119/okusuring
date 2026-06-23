# frozen_string_literal: true

class AddNotificationSettingsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :reminder_enabled, :boolean, default: true, null: false
    add_column :users, :reminder_interval, :integer, default: 10, null: false
  end
end
