require "grape_logging"

module API
  class Logger < ::GrapeLogging::Middleware::RequestLogger

    def before
      super
      logger.info information
    end

    protected

      def information
        {
          path: request.path,
          params: request.params.to_hash,
          method: request.request_method,
          token: env['HTTP_X_AUTH_TOKEN']
        }
      end

      def parameters
        [
          "Completed #{@app_response.status} in #{total_runtime}ms",
          "(ActiveRecord: #{@db_duration.round(2)}ms)",
          "token: #{env['HTTP_X_AUTH_TOKEN']}"
        ].join(' ')
      end

    private

      def logger
        @logger ||= (@options[:logger] || Rails.logger)
      end

      def request
        @request ||= ::Grape::Request.new(env)
      end
  end
end