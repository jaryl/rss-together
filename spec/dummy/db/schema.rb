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

ActiveRecord::Schema[7.0].define(version: 2022_03_11_025039) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "mark_source", ["system", "user"]

  create_table "rss_together_account_login_change_keys", force: :cascade do |t|
    t.string "key", null: false
    t.string "login", null: false
    t.datetime "deadline", null: false
  end

  create_table "rss_together_account_password_hashes", force: :cascade do |t|
    t.string "password_hash", null: false
  end

  create_table "rss_together_account_password_reset_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "deadline", null: false
    t.datetime "email_last_sent", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "rss_together_account_remember_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "deadline", null: false
  end

  create_table "rss_together_account_verification_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "requested_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "email_last_sent", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "rss_together_accounts", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.integer "status", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_rss_together_accounts_on_email", unique: true, where: "(status = ANY (ARRAY[1, 2]))"
  end

  create_table "rss_together_bookmarks", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "item_id"], name: "index_rss_together_bookmarks_on_account_id_and_item_id", unique: true
    t.index ["account_id"], name: "index_rss_together_bookmarks_on_account_id"
    t.index ["item_id"], name: "index_rss_together_bookmarks_on_item_id"
  end

  create_table "rss_together_comments", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "item_id", null: false
    t.string "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_rss_together_comments_on_account_id"
    t.index ["item_id"], name: "index_rss_together_comments_on_item_id"
  end

  create_table "rss_together_feeds", force: :cascade do |t|
    t.string "link", null: false
    t.string "title"
    t.string "description"
    t.string "language"
    t.datetime "processed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["link"], name: "index_rss_together_feeds_on_link", unique: true
  end

  create_table "rss_together_groups", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_rss_together_groups_on_owner_id"
  end

  create_table "rss_together_invitations", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "sender_id", null: false
    t.string "email", null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "email"], name: "index_rss_together_invitations_on_group_id_and_email", unique: true
    t.index ["group_id"], name: "index_rss_together_invitations_on_group_id"
    t.index ["sender_id"], name: "index_rss_together_invitations_on_sender_id"
    t.index ["token"], name: "index_rss_together_invitations_on_token", unique: true
  end

  create_table "rss_together_items", force: :cascade do |t|
    t.bigint "feed_id", null: false
    t.string "title", null: false
    t.string "content", null: false
    t.string "link", null: false
    t.string "description"
    t.string "author"
    t.datetime "published_at"
    t.string "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_rss_together_items_on_created_at"
    t.index ["feed_id"], name: "index_rss_together_items_on_feed_id"
  end

  create_table "rss_together_marks", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "item_id", null: false
    t.enum "source", default: "system", null: false, enum_type: "mark_source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "item_id"], name: "index_rss_together_marks_on_account_id_and_item_id", unique: true
    t.index ["account_id"], name: "index_rss_together_marks_on_account_id"
    t.index ["item_id"], name: "index_rss_together_marks_on_item_id"
  end

  create_table "rss_together_memberships", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "group_id", null: false
    t.string "display_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_rss_together_memberships_on_account_id"
    t.index ["group_id"], name: "index_rss_together_memberships_on_group_id"
  end

  create_table "rss_together_profiles", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "display_name", null: false
    t.string "timezone", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_rss_together_profiles_on_account_id"
  end

  create_table "rss_together_reactions", force: :cascade do |t|
    t.bigint "membership_id", null: false
    t.bigint "item_id", null: false
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id", "membership_id"], name: "index_rss_together_reactions_on_item_id_and_membership_id", unique: true
    t.index ["item_id"], name: "index_rss_together_reactions_on_item_id"
    t.index ["membership_id"], name: "index_rss_together_reactions_on_membership_id"
  end

  create_table "rss_together_subscriptions", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "feed_id", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_rss_together_subscriptions_on_account_id"
    t.index ["feed_id"], name: "index_rss_together_subscriptions_on_feed_id"
    t.index ["group_id", "feed_id"], name: "index_rss_together_subscriptions_on_group_id_and_feed_id", unique: true
    t.index ["group_id"], name: "index_rss_together_subscriptions_on_group_id"
  end

  add_foreign_key "rss_together_account_login_change_keys", "rss_together_accounts", column: "id"
  add_foreign_key "rss_together_account_password_hashes", "rss_together_accounts", column: "id"
  add_foreign_key "rss_together_account_password_reset_keys", "rss_together_accounts", column: "id"
  add_foreign_key "rss_together_account_remember_keys", "rss_together_accounts", column: "id"
  add_foreign_key "rss_together_account_verification_keys", "rss_together_accounts", column: "id"
  add_foreign_key "rss_together_bookmarks", "rss_together_accounts", column: "account_id"
  add_foreign_key "rss_together_bookmarks", "rss_together_items", column: "item_id"
  add_foreign_key "rss_together_comments", "rss_together_accounts", column: "account_id"
  add_foreign_key "rss_together_comments", "rss_together_items", column: "item_id"
  add_foreign_key "rss_together_groups", "rss_together_accounts", column: "owner_id"
  add_foreign_key "rss_together_invitations", "rss_together_accounts", column: "sender_id"
  add_foreign_key "rss_together_invitations", "rss_together_groups", column: "group_id"
  add_foreign_key "rss_together_items", "rss_together_feeds", column: "feed_id"
  add_foreign_key "rss_together_marks", "rss_together_accounts", column: "account_id"
  add_foreign_key "rss_together_marks", "rss_together_items", column: "item_id"
  add_foreign_key "rss_together_memberships", "rss_together_accounts", column: "account_id"
  add_foreign_key "rss_together_memberships", "rss_together_groups", column: "group_id"
  add_foreign_key "rss_together_profiles", "rss_together_accounts", column: "account_id"
  add_foreign_key "rss_together_reactions", "rss_together_items", column: "item_id"
  add_foreign_key "rss_together_reactions", "rss_together_memberships", column: "membership_id"
  add_foreign_key "rss_together_subscriptions", "rss_together_accounts", column: "account_id"
  add_foreign_key "rss_together_subscriptions", "rss_together_feeds", column: "feed_id"
  add_foreign_key "rss_together_subscriptions", "rss_together_groups", column: "group_id"
end
