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

ActiveRecord::Schema[7.0].define(version: 2022_02_11_103723) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "rss_together_items", force: :cascade do |t|
    t.bigint "feed_id", null: false
    t.string "title", null: false
    t.string "description", null: false
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feed_id"], name: "index_rss_together_items_on_feed_id"
  end

  create_table "rss_together_subscriptions", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "feed_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feed_id"], name: "index_rss_together_subscriptions_on_feed_id"
    t.index ["group_id"], name: "index_rss_together_subscriptions_on_group_id"
  end

  add_foreign_key "rss_together_items", "rss_together_feeds", column: "feed_id"
  add_foreign_key "rss_together_subscriptions", "rss_together_feeds", column: "feed_id"
  add_foreign_key "rss_together_subscriptions", "rss_together_groups", column: "group_id"
end
