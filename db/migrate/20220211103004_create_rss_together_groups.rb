class CreateRssTogetherGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :rss_together_groups do |t|
      t.references :owner, null: false, foreign_key: { to_table: :rss_together_accounts }, index: true

      t.string :name, null: false

      t.timestamps

      t.index :name
    end
  end
end
