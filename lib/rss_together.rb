require "rss_together/version"
require "rss_together/engine"

require "email_validator"
require "validate_url"
require "pundit"
require "faraday"

require "rss_together/test/auth_helpers"

module RssTogether
  class Error < StandardError; end

  class Engine < ::Rails::Engine
  end
end
