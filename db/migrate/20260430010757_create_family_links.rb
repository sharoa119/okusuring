# frozen_string_literal: true

class CreateFamilyLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :family_links do |t|
      t.integer :owner_user_id, null: false
      t.integer :member_user_id
      t.string :status, null: false, default: 'pending'
      t.string :token, null: false

      t.timestamps
    end

    add_index :family_links, :owner_user_id
    add_index :family_links, :member_user_id
    add_index :family_links, :token, unique: true
    add_index :family_links, %i[owner_user_id member_user_id], unique: true
  end
end
