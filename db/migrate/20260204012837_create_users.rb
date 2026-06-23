# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :line_user_id, null: false
      t.index :line_user_id, unique: true

      t.timestamps
    end
  end
end
