logger = if Rails.env.development?
  Logtail::Logger.new(STDOUT)
elsif Rails.env.test?
  Logtail::Logger.new("/dev/null")
end

Rails.logger = ActiveSupport::TaggedLogging.new(logger)

ActiveJob::Base.logger = Rails.logger

