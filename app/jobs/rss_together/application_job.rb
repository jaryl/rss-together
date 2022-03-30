module RssTogether
  class ApplicationJob < ActiveJob::Base
    include AfterCommitEverywhere

    def fail_with_feedback(resource:, error: nil)
      # TODO: check if feedback for this resource already exists

      ActiveRecord::Base.transaction do
        yield feedback = resource.feedback.build

        feedback.save!

        after_commit do
          RssTogether.error_reporter.call(error) unless error.nil?
        end
      end
    end
  end
end
