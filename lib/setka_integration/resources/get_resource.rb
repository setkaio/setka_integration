module SetkaIntegration
  module Resources
    class GetResource
      attr_reader :config, :opts

      def initialize(config, opts = '')
        @config = config
        @opts = opts
      end

      def call
        request.success? ? full_set : error
      end

      class << self
        def call(*args)
          new(*args).call
        end
      end

      private

      def error
        raise ::SetkaIntegration::Error, request.body['error']
      end

      def request
        raise NotImplementedError
      end

      def response_data
        request.success? ? (yield if block_given?) : error
      end
    end
  end
end
