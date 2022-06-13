source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in rss_together.gemspec.
gemspec

group :development, :test do
  # A PostgreSQL client library for Ruby
  gem "pg", "~> 1.3.1"
  # Detect non-atomic interactions within DB transactions
  gem "isolator"
  # Sprockets Rails integration
  gem "sprockets-rails"
  # Ruby on Rails Logtail integration
  gem "logtail-rails", "~> 0.1.6"
end

group :development do
  # Use the Puma web server [https://github.com/puma/puma]
  gem "puma", "~> 5.0"
end

group :test do
  # RSpec for Rails 5+
  gem "rspec-rails", "~> 5.0.0"
  # Simple one-liner tests for common Rails functionality
  gem "shoulda-matchers", "~> 5.0"
  # A library for setting up Ruby objects as test data
  gem "factory_bot_rails"
  # Library for stubbing and setting expectations on HTTP requests in Ruby
  gem "webmock"
  # Brings back `assigns` and `assert_template` to your Rails tests
  gem "rails-controller-testing"
  # A library for generating fake data such as names, addresses, and phone numbers
  gem "faker"
end
