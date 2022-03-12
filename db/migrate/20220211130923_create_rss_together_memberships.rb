class CreateRssTogetherMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :rss_together_memberships do |t|
      t.references :account, null: false, foreign_key: { to_table: :rss_together_accounts }, index: true
      t.references :group, null: false, foreign_key: { to_table: :rss_together_groups }, index: true

      t.string :display_name, null: true

      t.timestamps

      t.index [:group_id, :account_id], unique: true
    end
  end
end
