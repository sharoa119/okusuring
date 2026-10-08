# frozen_string_literal: true

class AddLinePictureUrlToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :line_picture_url, :string
  end
end
