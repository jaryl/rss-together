require 'devise'

require "rss_together/version"
require "rss_together/engine"

require "email_validator"

module RssTogether
  class Engine < ::Rails::Engine
    config.to_prepare do
      Devise::SessionsController.layout "basic"
      Devise::RegistrationsController.layout "basic"
      Devise::PasswordsController.layout "basic"
    end
  end
end
