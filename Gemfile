source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in rss_together.gemspec.
gemspec

gem "sprockets-rails"

# Start debugger with binding.b [https://github.com/ruby/debug]
# gem "debug", ">= 1.0.0"

gem "slim"

group :development, :test do
  # Simple one-liner tests for common Rails functionality
  gem "shoulda-matchers", "~> 5.0"

  # A library for setting up Ruby objects as test data
  gem "factory_bot_rails"

  # Brings back `assigns` and `assert_template` to your Rails tests
  gem "rails-controller-testing"

  # A library for generating fake data such as names, addresses, and phone numbers
  gem "faker"
end
