# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_06_08_015655) do
  create_table "family_links", force: :cascade do |t|
    t.integer "owner_user_id", null: false
    t.integer "member_user_id"
    t.string "status", default: "pending", null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_user_id"], name: "index_family_links_on_member_user_id"
    t.index ["owner_user_id", "member_user_id"], name: "index_family_links_on_owner_user_id_and_member_user_id", unique: true
    t.index ["owner_user_id"], name: "index_family_links_on_owner_user_id"
    t.index ["token"], name: "index_family_links_on_token", unique: true
  end

  create_table "medication_records", force: :cascade do |t|
    t.integer "medication_time_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "taken_date", null: false
    t.index ["medication_time_id", "taken_date"], name: "index_medication_records_on_time_and_date", unique: true
    t.index ["medication_time_id"], name: "index_medication_records_on_medication_time_id"
  end

  create_table "medication_schedules", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", null: false
    t.string "target_name", null: false
    t.text "memo"
    t.integer "reminder_interval", default: 5, null: false
    t.boolean "reminder_enabled", default: true, null: false
    t.index ["user_id"], name: "index_medication_schedules_on_user_id"
  end

  create_table "medication_times", force: :cascade do |t|
    t.integer "medication_schedule_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "time", null: false
    t.index ["medication_schedule_id"], name: "index_medication_times_on_medication_schedule_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "line_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.boolean "line_bot_connected", default: false, null: false
    t.boolean "reminder_enabled", default: true, null: false
    t.integer "reminder_interval", default: 10, null: false
    t.index ["line_user_id"], name: "index_users_on_line_user_id", unique: true
  end

  add_foreign_key "medication_records", "medication_times"
  add_foreign_key "medication_schedules", "users"
  add_foreign_key "medication_times", "medication_schedules"
end
