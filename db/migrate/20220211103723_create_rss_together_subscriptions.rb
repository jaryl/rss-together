class CreateRssTogetherSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :rss_together_subscriptions do |t|
      t.references :group, null: false, foreign_key: { to_table: :rss_together_groups }, index: true
      t.references :feed, null: false, foreign_key: { to_table: :rss_together_feeds }, index: true
      t.references :account, null: false, foreign_key: { to_table: :rss_together_accounts }, index: true

      t.datetime :processed_at, null: true

      t.timestamps

      t.index [:group_id, :feed_id], unique: true
    end
  end
end
