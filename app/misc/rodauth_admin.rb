class RodauthAdmin < Rodauth::Rails::Auth
  configure do

    # ... enable features ...

    # prefix "/admin"
    # session_key_prefix "admin_"
    # remember_cookie_key "_admin_remember" # if using remember feature

    # rails_controller { Admin::RodauthController }
  end
end
