class CreateRssTogetherFeeds < ActiveRecord::Migration[7.0]
  def change
    create_table :rss_together_feeds do |t|
      t.string :url, null: false
      t.datetime :last_refreshed_at

      t.timestamps
    end
  end
end
