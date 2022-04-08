module RssTogether
  class ApplicationJob < ActiveJob::Base
    include AfterCommitEverywhere

    rescue_from StandardError, with: :report_error

    def fail_with_feedback(resource:, error: nil, **kwargs)
      # TODO: check if feedback for this resource already exists

      key = error.present? ? error.class.name : "Unknown"

      ActiveRecord::Base.transaction do
        yield feedback = resource.feedback.find_or_initialize_by(key: error&.class&.name)

        feedback.save!

        after_commit do
          report_error(error, **kwargs) if error.present?
        end
      end
    end

    private

    def report_error(error, **kwargs)
      kwargs[:sync] = true
      kwargs[:tags] ||= []
      kwargs[:tags] << "active-job"

      kwargs[:parameters] = arguments.inject({}) do |acc, arg|
        if arg.respond_to?(:to_global_id)
          acc[acc.length] = arg.to_global_id.to_s
        else
          acc[acc.length] = arg
        end
        acc
      end

      RssTogether.error_reporter.call(error, **kwargs)
    end
  end
end
