# frozen_string_literal: true

class CreateRssTogetherAccountsWithRodauth < ActiveRecord::Migration[7.0]
  enable_extension "citext"

  def change
    create_table :rss_together_accounts do |t|
      t.string :email, null: false, default: ""
      t.integer :status, null: false, default: 1

      t.timestamps null: false

      t.index :email, unique: true, where: "status IN (1, 2)"
    end

    # Used if storing password hashes in a separate table (default)
    create_table :rss_together_account_password_hashes do |t|
      t.foreign_key :rss_together_accounts, column: :id
      t.string :password_hash, null: false
    end

    # Used by the password reset feature
    create_table :rss_together_account_password_reset_keys do |t|
      t.foreign_key :rss_together_accounts, column: :id
      t.string :key, null: false
      t.datetime :deadline, null: false
      t.datetime :email_last_sent, null: false, default: -> { "CURRENT_TIMESTAMP" }
    end

    # Used by the account verification feature
    create_table :rss_together_account_verification_keys do |t|
      t.foreign_key :rss_together_accounts, column: :id
      t.string :key, null: false
      t.datetime :requested_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :email_last_sent, null: false, default: -> { "CURRENT_TIMESTAMP" }
    end

    # Used by the verify login change feature
    create_table :rss_together_account_login_change_keys do |t|
      t.foreign_key :rss_together_accounts, column: :id
      t.string :key, null: false
      t.string :login, null: false
      t.datetime :deadline, null: false
    end

    # Used by the remember me feature
    create_table :rss_together_account_remember_keys do |t|
      t.foreign_key :rss_together_accounts, column: :id
      t.string :key, null: false
      t.datetime :deadline, null: false
    end
  end
end
