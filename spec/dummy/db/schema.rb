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

ActiveRecord::Schema[7.0].define(version: 2022_02_12_154647) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "rss_together_accounts", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_rss_together_accounts_on_email", unique: true
    t.index ["reset_password_token"], name: "index_rss_together_accounts_on_reset_password_token", unique: true
  end

  create_table "rss_together_bookmarks", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_rss_together_bookmarks_on_account_id"
    t.index ["item_id"], name: "index_rss_together_bookmarks_on_item_id"
  end

  create_table "rss_together_feeds", force: :cascade do |t|
    t.string "url", null: false
    t.datetime "last_refreshed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rss_together_groups", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rss_together_invitations", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.string "email", null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "email"], name: "index_rss_together_invitations_on_group_id_and_email", unique: true
    t.index ["group_id"], name: "index_rss_together_invitations_on_group_id"
    t.index ["token"], name: "index_rss_together_invitations_on_token", unique: true
  end

  create_table "rss_together_items", force: :cascade do |t|
    t.bigint "feed_id", null: false
    t.string "title", null: false
    t.string "description", null: false
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feed_id"], name: "index_rss_together_items_on_feed_id"
  end

  create_table "rss_together_memberships", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_rss_together_memberships_on_account_id"
    t.index ["group_id"], name: "index_rss_together_memberships_on_group_id"
  end

  create_table "rss_together_subscriptions", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "feed_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feed_id"], name: "index_rss_together_subscriptions_on_feed_id"
    t.index ["group_id"], name: "index_rss_together_subscriptions_on_group_id"
  end

  add_foreign_key "rss_together_bookmarks", "rss_together_accounts", column: "account_id"
  add_foreign_key "rss_together_bookmarks", "rss_together_items", column: "item_id"
  add_foreign_key "rss_together_invitations", "rss_together_groups", column: "group_id"
  add_foreign_key "rss_together_items", "rss_together_feeds", column: "feed_id"
  add_foreign_key "rss_together_memberships", "rss_together_accounts", column: "account_id"
  add_foreign_key "rss_together_memberships", "rss_together_groups", column: "group_id"
  add_foreign_key "rss_together_subscriptions", "rss_together_feeds", column: "feed_id"
  add_foreign_key "rss_together_subscriptions", "rss_together_groups", column: "group_id"
end
