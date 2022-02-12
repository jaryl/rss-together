class CreateRssTogetherBookmarks < ActiveRecord::Migration[7.0]
  def change
    create_table :rss_together_bookmarks do |t|
      t.references :account, null: false, foreign_key: { to_table: :rss_together_accounts }, index: true
      t.references :item, null: false, foreign_key: { to_table: :rss_together_items }, index: true

      t.timestamps
    end
  end
end
