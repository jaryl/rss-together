class RodauthMain < Rodauth::Rails::Auth
  configure do
    # List of authentication features that are loaded.
    enable :create_account, :verify_account, :verify_account_grace_period,
      :login, :logout, :remember,
      :reset_password, :change_password, :change_password_notify,
      :change_login, :verify_login_change, :close_account

    login_route "sign_in"

    # See the Rodauth documentation for the list of available config options:
    # http://rodauth.jeremyevans.net/documentation.html

    # ==> General
    # The secret key used for hashing public-facing tokens for various features.
    # Defaults to Rails `secret_key_base`, but you can use your own secret key.
    # hmac_secret "a0396e7404ec0cd0a46ff179f8c35246131d293b5b4aaa1fccce5f8379b9421254d9c2e312148773c55f6917830c8c6d59b607f4a31fff6edfc3b6fc4858db37"

    # Specify the controller used for view rendering and CSRF verification.
    rails_controller { RodauthController }

    # Store account status in an integer column without foreign key constraint.
    account_status_column :status

    # Store password hash in a column instead of a separate table.
    # account_password_hash_column :password_digest

    # Set password when creating account instead of when verifying.
    verify_account_set_password? false

    enable :internal_request if Rails.env.test?

    reset_password_email_last_sent_column nil if Rails.env.development?
    verify_account_email_last_sent_column nil if Rails.env.development?

    # Redirect back to originally requested location after authentication.
    # login_return_to_requested_location? true
    # two_factor_auth_return_to_requested_location? true # if using MFA

    # Autologin the user after they have reset their password.
    reset_password_autologin? true

    # Delete the account record when the user has closed their account.
    # delete_account_on_close? true

    # Redirect to the app from login and registration pages if already logged in.
    already_logged_in { redirect login_redirect }

    # ==> Emails
    # Use a custom mailer for delivering authentication emails.
    create_reset_password_email do
      RodauthMailer.reset_password(account_id, reset_password_key_value)
    end
    create_verify_account_email do
      RodauthMailer.verify_account(account_id, verify_account_key_value)
    end
    create_verify_login_change_email do |_login|
      RodauthMailer.verify_login_change(account_id, verify_login_change_old_login, verify_login_change_new_login, verify_login_change_key_value)
    end
    create_password_changed_email do
      RodauthMailer.password_changed(account_id)
    end
    # create_email_auth_email do
    #   RodauthMailer.email_auth(account_id, email_auth_key_value)
    # end
    # create_unlock_account_email do
    #   RodauthMailer.unlock_account(account_id, unlock_account_key_value)
    # end
    send_email do |email|
      # queue email delivery on the mailer after the transaction commits
      db.after_commit { email.deliver_later }
    end

    # ==> Flash
    # Match flash keys with ones already used in the Rails app.
    # flash_notice_key :success # default is :notice
    # flash_error_key :error # default is :alert

    # Override default flash messages.
    # create_account_notice_flash "Your account has been created. Please verify your account by visiting the confirmation link sent to your email address."
    # require_login_error_flash "Login is required for accessing this page"
    # login_notice_flash nil

    # ==> Validation
    # Override default validation error messages.
    # no_matching_login_message "user with this email address doesn't exist"
    # already_an_account_with_this_login_message "user with this email address already exists"
    # password_too_short_message { "needs to have at least #{password_minimum_length} characters" }
    # login_does_not_meet_requirements_message { "invalid email#{", #{login_requirement_message}" if login_requirement_message}" }

    # Change minimum number of password characters required when creating an account.
    # password_minimum_length 8

    # ==> Remember Feature
    # Remember all logged in users.
    after_login { remember_login }

    # Or only remember users that have ticked a "Remember Me" checkbox on login.
    # after_login { remember_login if param_or_nil("remember") }

    # Extend user's remember period when remembered via a cookie
    extend_remember_deadline? true

    # ==> Hooks
    # Validate custom fields in the create account form.
    before_create_account do
      account[:created_at] = Time.current
      account[:updated_at] = Time.current

      throw_error_status(422, "display_name", "must be present") if param("display_name").empty?
    end

    # Perform additional actions after the account is created.
    after_create_account do
      RssTogether::Profile.create!(
        account_id: account_id,
        display_name: param("display_name"),
        timezone: param("timezone").blank? ? "Etc/UTC" : param("timezone"),
      )
    end

    # Do additional cleanup after the account is closed.
    after_close_account do
      RssTogether::Profile.find_by!(account_id: account_id).destroy
    end

    # ==> Redirects
    # Redirect to home page after logout.
    logout_redirect "/sign_in"

    login_redirect { rails_routes.reader_path }
    change_login_redirect { rails_routes.settings_email_path }
    change_password_redirect { change_password_path }
    remember_redirect { remember_path }

    require_login_redirect { login_path }

    # Redirect to wherever login redirects to after account verification.
    verify_account_redirect { login_redirect }
    verify_account_email_sent_redirect { rails_routes.settings_email_path }
    verify_account_email_recently_sent_redirect { rails_routes.settings_email_path }

    # Redirect to login page after password reset.
    reset_password_redirect { login_path }
    reset_password_email_sent_redirect { login_path }

    # ==> Deadlines
    # Change default deadlines for some actions.
    # verify_account_grace_period 3.days
    # reset_password_deadline_interval Hash[hours: 6]
    # verify_login_change_deadline_interval Hash[days: 2]
    # remember_deadline_interval Hash[days: 30]

    login_label "Email"

    create_account_route "sign_up"

    accounts_table :rss_together_accounts
    password_hash_table :rss_together_account_password_hashes
    reset_password_table :rss_together_account_password_reset_keys
    verify_account_table :rss_together_account_verification_keys
    verify_login_change_table :rss_together_account_login_change_keys
    remember_table :rss_together_account_remember_keys

    rails_account_model { RssTogether::Account }
  end
end
