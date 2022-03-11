class CreateRssTogetherGroupTransfers < ActiveRecord::Migration[7.0]
  def change
    create_table :rss_together_group_transfers do |t|
      t.references :group, null: false, foreign_key: { to_table: :rss_together_groups }, index: true, unique: true
      t.references :recipient, null: false, foreign_key: { to_table: :rss_together_memberships }, index: true

      t.timestamps
    end
  end
end
