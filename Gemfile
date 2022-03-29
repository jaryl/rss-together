source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in rss_together.gemspec.
gemspec

gem "sprockets-rails"

# Start debugger with binding.b [https://github.com/ruby/debug]
# gem "debug", ">= 1.0.0"

#  Slim is a template language whose goal is to reduce the syntax to the essential parts without becoming cryptic
gem "slim"
# URL Validation for Rails
gem "validate_url"
# Rails integration for Rodauth authentication framework
gem "rodauth-rails", "~> 1.2"
# Use ActiveRecord transactional callbacks outside of models, literally everywhere in your application
gem "after_commit_everywhere"
# Minimal authorization through OO design and pure Ruby classes
gem "pundit"
# Simple, but flexible HTTP client library, with support for multiple backends
gem "faraday"
# Catches exceptions and retries each request a limited number of times
gem "faraday-retry"
# Faraday 2.x compatible extraction of FaradayMiddleware::FollowRedirects
gem "faraday-follow_redirects"

group :development, :test do
  # Simple one-liner tests for common Rails functionality
  gem "shoulda-matchers", "~> 5.0"

  # A library for setting up Ruby objects as test data
  gem "factory_bot_rails"

  # Brings back `assigns` and `assert_template` to your Rails tests
  gem "rails-controller-testing"

  # A library for generating fake data such as names, addresses, and phone numbers
  gem "faker"

  # Detect non-atomic interactions within DB transactions
  gem "isolator"


end

group :test do
  # Library for stubbing and setting expectations on HTTP requests in Ruby
  gem "webmock"
end
