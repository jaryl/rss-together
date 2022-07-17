class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  discard_on ActiveJob::DeserializationError

  def fail_with_feedback(resource:, error:, **kwargs)
    yield OpenStruct.new(message: "")
    log_and_report_error(error, **kwargs) if error.present?
  end
end
