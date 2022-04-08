# See https://github.com/rspec/rspec-rails/issues/2545#issuecomment-1029539971
if Rails::VERSION::MAJOR >= 7
  require 'rspec/rails/version'

  RSpec::Core::ExampleGroup.module_eval do
    include ActiveSupport::Testing::TaggedLogging

    def name
      'foobar'
    end
  end
end
