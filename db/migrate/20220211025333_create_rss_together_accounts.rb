# frozen_string_literal: true

class CreateRssTogetherAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :rss_together_accounts do |t|
      t.string :email, null: false, default: ""
      t.string :password, null: false, default: ""

      t.timestamps null: false
    end

    add_index :rss_together_accounts, :email,                unique: true
  end
end
