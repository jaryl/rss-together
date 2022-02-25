class CreateRssTogetherMarks < ActiveRecord::Migration[7.0]
  def change
    create_enum :mark_source, ["system", "user"]

    create_table :rss_together_marks do |t|
      t.references :account, null: false, foreign_key: { to_table: :rss_together_accounts }, index: true
      t.references :item, null: false, foreign_key: { to_table: :rss_together_items }, index: true

      t.enum :source, enum_type: :mark_source, default: "system", null: false

      t.timestamps

      t.index [:account_id, :item_id], unique: true
    end
  end

  def down
    drop_table :rss_together_marks

    execute <<-SQL
      DROP TYPE mark_source;
    SQL
  end
end
