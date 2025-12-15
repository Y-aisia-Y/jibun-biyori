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

ActiveRecord::Schema[7.1].define(version: 2025_12_15_132747) do
  create_table "activities", force: :cascade do |t|
    t.integer "record_id", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_id"], name: "index_activities_on_record_id"
  end

  create_table "moods", force: :cascade do |t|
    t.integer "record_id", null: false
    t.integer "rating", null: false
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_id"], name: "index_moods_on_record_id", unique: true
  end

  create_table "record_items", force: :cascade do |t|
    t.string "name"
    t.integer "input_type"
    t.boolean "is_default_visible"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "display_order"
    t.index ["display_order"], name: "index_record_items_on_display_order"
  end

  create_table "record_values", force: :cascade do |t|
    t.integer "record_id", null: false
    t.integer "record_item_id", null: false
    t.string "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.time "sleep_time"
    t.time "wake_time"
    t.string "value_type"
    t.index ["record_id"], name: "index_record_values_on_record_id"
    t.index ["record_item_id"], name: "index_record_values_on_record_item_id"
  end

  create_table "records", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "recorded_date"
    t.text "diary_memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_records_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "activities", "records"
  add_foreign_key "moods", "records"
  add_foreign_key "record_values", "record_items"
  add_foreign_key "record_values", "records"
  add_foreign_key "records", "users"
end
