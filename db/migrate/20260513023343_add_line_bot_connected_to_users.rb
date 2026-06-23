# frozen_string_literal: true

class AddLineBotConnectedToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users,
               :line_bot_connected,
               :boolean,
               default: false,
               null: false
  end
end
