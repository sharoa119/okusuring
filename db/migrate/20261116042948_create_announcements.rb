# frozen_string_literal: true

class CreateAnnouncements < ActiveRecord::Migration[8.1]
  def change
    create_table :announcements do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.string :category, null: false
      t.datetime :published_at

      t.timestamps
    end
  end
end
