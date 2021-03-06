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

ActiveRecord::Schema[7.0].define(version: 2022_06_17_101950) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "account_status", ["unverified", "verified", "closed"]
  create_enum "mark_source", ["system", "user"]
  create_enum "subscription_request_status", ["pending", "success", "failure"]

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
    t.enum "status", default: "unverified", null: false, enum_type: "account_status"
    t.boolean "enabled", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_rss_together_accounts_on_email", unique: true, where: "(status = ANY (ARRAY['unverified'::account_status, 'verified'::account_status]))"
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
    t.bigint "author_id", null: false
    t.bigint "item_id", null: false
    t.string "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_rss_together_comments_on_author_id"
    t.index ["item_id"], name: "index_rss_together_comments_on_item_id"
  end

  create_table "rss_together_feeds", force: :cascade do |t|
    t.string "link", null: false
    t.string "title"
    t.string "description"
    t.string "language"
    t.datetime "processed_at"
    t.boolean "enabled", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["link"], name: "index_rss_together_feeds_on_link", unique: true
    t.index ["processed_at"], name: "index_rss_together_feeds_on_processed_at"
    t.index ["title"], name: "index_rss_together_feeds_on_title"
  end

  create_table "rss_together_group_transfers", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "recipient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_rss_together_group_transfers_on_group_id"
    t.index ["recipient_id"], name: "index_rss_together_group_transfers_on_recipient_id"
  end

  create_table "rss_together_groups", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_rss_together_groups_on_name"
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
    t.string "guid"
    t.datetime "published_at"
    t.datetime "rejected_published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_rss_together_items_on_created_at"
    t.index ["feed_id"], name: "index_rss_together_items_on_feed_id"
    t.index ["published_at"], name: "index_rss_together_items_on_published_at"
  end

  create_table "rss_together_marks", force: :cascade do |t|
    t.bigint "reader_id", null: false
    t.bigint "item_id", null: false
    t.boolean "unread", default: true, null: false
    t.enum "source", default: "system", null: false, enum_type: "mark_source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_rss_together_marks_on_item_id"
    t.index ["reader_id", "item_id"], name: "index_rss_together_marks_on_reader_id_and_item_id", unique: true
    t.index ["reader_id"], name: "index_rss_together_marks_on_reader_id"
  end

  create_table "rss_together_memberships", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "group_id", null: false
    t.string "display_name_override"
    t.integer "recommendation_threshold_override"
    t.integer "unread_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_rss_together_memberships_on_account_id"
    t.index ["group_id", "account_id"], name: "index_rss_together_memberships_on_group_id_and_account_id", unique: true
    t.index ["group_id"], name: "index_rss_together_memberships_on_group_id"
  end

  create_table "rss_together_profiles", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "display_name", null: false
    t.integer "recommendation_threshold"
    t.string "timezone", null: false
    t.integer "bookmarks_count", default: 0, null: false
    t.boolean "onboarded", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_rss_together_profiles_on_account_id"
    t.index ["display_name"], name: "index_rss_together_profiles_on_display_name"
  end

  create_table "rss_together_recommendations", force: :cascade do |t|
    t.bigint "membership_id", null: false
    t.bigint "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id", "membership_id"], name: "index_rss_together_recommendations_on_item_id_and_membership_id", unique: true
    t.index ["item_id"], name: "index_rss_together_recommendations_on_item_id"
    t.index ["membership_id"], name: "index_rss_together_recommendations_on_membership_id"
  end

  create_table "rss_together_subscription_requests", force: :cascade do |t|
    t.bigint "membership_id", null: false
    t.enum "status", default: "pending", null: false, enum_type: "subscription_request_status"
    t.string "target_url", null: false
    t.string "original_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["membership_id"], name: "index_rss_together_subscription_requests_on_membership_id"
  end

  create_table "rss_together_subscriptions", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "feed_id", null: false
    t.bigint "account_id", null: false
    t.datetime "processed_at"
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
  add_foreign_key "rss_together_comments", "rss_together_items", column: "item_id"
  add_foreign_key "rss_together_comments", "rss_together_memberships", column: "author_id"
  add_foreign_key "rss_together_group_transfers", "rss_together_groups", column: "group_id"
  add_foreign_key "rss_together_group_transfers", "rss_together_memberships", column: "recipient_id"
  add_foreign_key "rss_together_groups", "rss_together_accounts", column: "owner_id"
  add_foreign_key "rss_together_invitations", "rss_together_groups", column: "group_id"
  add_foreign_key "rss_together_invitations", "rss_together_memberships", column: "sender_id"
  add_foreign_key "rss_together_items", "rss_together_feeds", column: "feed_id"
  add_foreign_key "rss_together_marks", "rss_together_items", column: "item_id"
  add_foreign_key "rss_together_marks", "rss_together_memberships", column: "reader_id"
  add_foreign_key "rss_together_memberships", "rss_together_accounts", column: "account_id"
  add_foreign_key "rss_together_memberships", "rss_together_groups", column: "group_id"
  add_foreign_key "rss_together_profiles", "rss_together_accounts", column: "account_id"
  add_foreign_key "rss_together_recommendations", "rss_together_items", column: "item_id"
  add_foreign_key "rss_together_recommendations", "rss_together_memberships", column: "membership_id"
  add_foreign_key "rss_together_subscription_requests", "rss_together_memberships", column: "membership_id"
  add_foreign_key "rss_together_subscriptions", "rss_together_accounts", column: "account_id"
  add_foreign_key "rss_together_subscriptions", "rss_together_feeds", column: "feed_id"
  add_foreign_key "rss_together_subscriptions", "rss_together_groups", column: "group_id"
end
