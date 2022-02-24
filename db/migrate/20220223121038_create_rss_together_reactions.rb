class CreateRssTogetherReactions < ActiveRecord::Migration[7.0]
  def change
    create_table :rss_together_reactions do |t|
      t.references :membership, null: false, foreign_key: { to_table: :rss_together_memberships }, index: true
      t.references :item, null: false, foreign_key: { to_table: :rss_together_items }, index: true

      t.string :value

      t.timestamps

      t.index [:item_id, :membership_id], unique: true
    end
  end
end
