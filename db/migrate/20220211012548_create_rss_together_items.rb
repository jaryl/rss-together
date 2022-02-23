class CreateRssTogetherItems < ActiveRecord::Migration[7.0]
  def change
    create_table :rss_together_items do |t|
      t.references :feed, null: false, foreign_key: { to_table: :rss_together_feeds }, index: true

      t.string :title, null: false
      t.string :content, null: false
      t.string :link, null: false

      t.string :description, null: true
      t.string :author, null: true
      t.datetime :published_at, null: true
      t.string :guid, null: true

      t.timestamps
    end
  end
end
