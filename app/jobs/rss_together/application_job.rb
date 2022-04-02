module RssTogether
  class ApplicationJob < ActiveJob::Base
    include AfterCommitEverywhere

    rescue_from(StandardError) do |error|
      RssTogether.error_reporter.call(
        error,
        sync: true,
        tags: "active-job",
      )
    end

    def fail_with_feedback(resource:, error: nil, context: {})
      # TODO: check if feedback for this resource already exists

      ActiveRecord::Base.transaction do
        yield feedback = resource.feedback.build

        feedback.save!

        after_commit do
          kwargs = {
            sync: true,
            tags: "active-job",
            context: context,
          }
          RssTogether.error_reporter.call(error, **kwargs) unless error.nil?
        end
      end
    end
  end
end
