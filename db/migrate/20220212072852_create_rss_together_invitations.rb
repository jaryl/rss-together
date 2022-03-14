class CreateRssTogetherInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :rss_together_invitations do |t|
      t.references :group, null: false, foreign_key: { to_table: :rss_together_groups }, index: true
      t.references :sender, null: false, foreign_key: { to_table: :rss_together_memberships }, index: true

      t.string :email, null: false
      t.string :token, null: false, index: { unique: true }

      t.timestamps

      t.index [:group_id, :email], unique: true
    end
  end
end
