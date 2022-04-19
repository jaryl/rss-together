class CreateRssTogetherSubscriptionRequests < ActiveRecord::Migration[7.0]
  def up
    create_enum :subscription_request_status, ["pending", "success", "failure"]

    create_table :rss_together_subscription_requests do |t|
      t.references :membership, null: false, foreign_key: { to_table: :rss_together_memberships }, index: true

      t.enum :status, enum_type: :subscription_request_status, default: "pending", null: false

      t.string :target_url, null: false
      t.string :original_url, null: false

      t.timestamps
    end
  end

  def down
    drop_table :rss_together_subscription_requests

    execute <<-SQL
      DROP TYPE subscription_request_status;
    SQL
  end
end
