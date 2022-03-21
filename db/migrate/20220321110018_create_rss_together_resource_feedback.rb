class CreateRssTogetherResourceFeedback < ActiveRecord::Migration[7.0]
  def change
    create_enum :resource_feedback_status, ["pending", "resolved", "dismissed"]

    create_table :rss_together_resource_feedback do |t|
      t.references :resource, polymorphic: true, index: true

      t.enum :status, enum_type: :resource_feedback_status, default: "pending", null: false

      t.string :title, null: false
      t.string :message, null: false

      t.timestamps
    end
  end
end
