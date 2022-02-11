class CreateRssTogetherGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :rss_together_groups do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
