class CreateRssTogetherProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :rss_together_profiles do |t|
      t.references :account, null: false, foreign_key: { to_table: :rss_together_accounts }, index: true

      t.string :display_name, null: false
      t.string :timezone, null: false

      t.boolean :onboarded, default: false

      t.timestamps

      t.index :display_name
    end
  end
end
