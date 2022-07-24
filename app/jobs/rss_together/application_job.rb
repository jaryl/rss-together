module RssTogether
  class ApplicationJob < ::ApplicationJob
    rescue_from StandardError, with: :log_and_report_error

    REPORTING_TAGS = ["active-job"].freeze

    def default_context
      { job_class: self.class.to_s }
    end

    def resource
      nil
    end

    def fail_with_resource(message, &block)
      instance_eval(&block) if block
      super
    end

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

      kwargs[:context] = (kwargs[:context] || {}).merge(default_context)

      logger.error(error.message, error: error.class.name, **kwargs)

      RssTogether.error_reporter.call(error, **kwargs.merge(sync: true))
    end
  end
end
