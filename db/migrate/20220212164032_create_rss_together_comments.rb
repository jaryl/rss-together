class CreateRssTogetherComments < ActiveRecord::Migration[7.0]
  def change
    create_table :rss_together_comments do |t|
      t.references :author, null: false, foreign_key: { to_table: :rss_together_memberships }, index: true
      t.references :item, null: false, foreign_key: { to_table: :rss_together_items }, index: true

      t.string :content, null: false

      t.timestamps
    end
  end
end
