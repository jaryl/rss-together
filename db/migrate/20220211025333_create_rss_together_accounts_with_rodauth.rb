# frozen_string_literal: true

class CreateRssTogetherAccountsWithRodauth < ActiveRecord::Migration[7.0]
  enable_extension "citext"

  create_enum :account_status, ["unverified", "verified", "closed"]

  def change
    create_table :rss_together_accounts do |t|
      t.string :email, null: false, default: ""

      t.enum :status, enum_type: :account_status, default: "unverified", null: false
      t.boolean :enabled, null: false, default: true

      t.timestamps null: false

      t.index :email, unique: true, where: "status IN ('unverified', 'verified')"
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
