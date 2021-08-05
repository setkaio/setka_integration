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

      def struct
        Struct.new(*hash_keys)
      end

      def hash_data
        hash_keys.inject({}) do |hash, key|
          hash.merge({ key => public_send(key) })
        end
      end

      def full_set
        struct.new(*hash_data.values)
      end

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
