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

ActiveRecord::Schema[8.0].define(version: 2025_07_23_200247) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "branch"
  end

  create_table "contacts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "contact_id", null: false
    t.boolean "accepted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_contacts_on_contact_id"
    t.index ["user_id", "contact_id"], name: "index_contacts_on_user_id_and_contact_id", unique: true
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "group_conversations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_conversations_users", id: false, force: :cascade do |t|
    t.bigint "group_conversation_id", null: false
    t.bigint "user_id", null: false
    t.index ["group_conversation_id", "user_id"], name: "index_gc_users_on_conversation_and_user", unique: true
    t.index ["group_conversation_id"], name: "index_group_conversations_users_on_group_conversation_id"
    t.index ["user_id"], name: "index_group_conversations_users_on_user_id"
  end

  create_table "group_messages", force: :cascade do |t|
    t.text "content", null: false
    t.text "seen_by"
    t.text "added_new_users"
    t.bigint "user_id", null: false
    t.bigint "conversation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_group_messages_on_conversation_id"
    t.index ["user_id"], name: "index_group_messages_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "category_id", null: false
    t.string "title"
    t.text "content"
    t.index ["category_id"], name: "index_posts_on_category_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "private_conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sender_id"
    t.integer "recipient_id"
    t.bigint "post_id"
    t.index ["post_id"], name: "index_private_conversations_on_post_id"
  end

  create_table "private_messages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "body"
    t.integer "sender_id"
    t.integer "conversation_id"
    t.boolean "seen"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "contacts", "users"
  add_foreign_key "contacts", "users", column: "contact_id"
  add_foreign_key "group_conversations_users", "group_conversations"
  add_foreign_key "group_conversations_users", "users"
  add_foreign_key "group_messages", "group_conversations", column: "conversation_id"
  add_foreign_key "group_messages", "users"
  add_foreign_key "posts", "categories"
  add_foreign_key "posts", "users"
  add_foreign_key "private_conversations", "posts"
end
