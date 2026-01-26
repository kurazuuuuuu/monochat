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

ActiveRecord::Schema[8.1].define(version: 2026_01_16_064334) do
  create_table "messages", force: :cascade do |t|
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.string "message_uuid", limit: 36, null: false
    t.string "sender_uuid", limit: 36, null: false
    t.string "space_uuid", limit: 36, null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_messages_on_created_at"
    t.index ["message_uuid"], name: "index_messages_on_message_uuid", unique: true
    t.index ["sender_uuid"], name: "index_messages_on_sender_uuid"
    t.index ["space_uuid"], name: "index_messages_on_space_uuid"
  end

  create_table "spaces", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "space_name", null: false
    t.string "space_uuid", limit: 36, null: false
    t.datetime "updated_at", null: false
    t.index ["space_uuid"], name: "index_spaces_on_space_uuid", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.string "user_name", null: false
    t.string "user_uuid", limit: 36, null: false
    t.index ["user_name"], name: "index_users_on_user_name", unique: true
    t.index ["user_uuid"], name: "index_users_on_user_uuid", unique: true
  end
end
