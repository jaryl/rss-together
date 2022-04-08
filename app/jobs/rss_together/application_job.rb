module RssTogether
  class ApplicationJob < ActiveJob::Base
    include AfterCommitEverywhere

    rescue_from StandardError, with: :log_and_report_error

    DEFAULT_FEEDBACK_KEY = "Unknown".freeze
    REPORTING_TAGS = ["active-job"].freeze

    def fail_with_feedback(resource:, error:, **kwargs)
      key = error.present? ? error.class.name : DEFAULT_FEEDBACK_KEY
      ActiveRecord::Base.transaction do
        yield feedback = resource.feedback.find_or_initialize_by(key: error&.class&.name)

        feedback.save!

        after_commit do
          log_and_report_error(error, **kwargs) if error.present?
        end
      end
    end

    private

    def log_and_report_error(error, **kwargs)
      kwargs[:tags] ||= []
      kwargs[:tags].concat(REPORTING_TAGS).uniq!

      kwargs[:parameters] = arguments.inject({}) do |acc, arg|
        if arg.respond_to?(:to_global_id)
          acc[acc.length] = arg.to_global_id.to_s
        else
          acc[acc.length] = arg
        end
        acc
      end

      puts RssTogether.logger.inspect

      RssTogether.logger.error(error.message, error: error.class.name, **kwargs)
      RssTogether.error_reporter.call(error, **kwargs.merge(sync: true))
    end
  end
end
