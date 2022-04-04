class CreateRssTogetherFeeds < ActiveRecord::Migration[7.0]
  def change
    create_table :rss_together_feeds do |t|
      t.string :link, null: false

      t.string :title, null: true
      t.string :description, null: true
      t.string :language, null: true

      t.datetime :processed_at, null: true
      t.boolean :enabled, null: false, default: true

      t.timestamps

      t.index :link, unique: true
      t.index :processed_at
    end
  end
end
