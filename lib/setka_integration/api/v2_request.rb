module SetkaIntegration
  module Api
    class V2Request
      def initialize(params = {})
        @params = params
      end

      def call
        uri = URI(endpoint)
        uri.query = URI.encode_www_form(request_params) unless allowed_params.empty?

        @response = Net::HTTP.get_response(uri)
        self
      end

      class << self
        def call(*args)
          new(*args).()
        end
      end

      def success?
        response.code.to_i == 200
      end

      def non_authorized?
        response.code.to_i == 301
      end

      def body
        JSON.parse(response.body)
      end

      private

      def endpoint
        "#{host}/api/v2/integration"
      end

      def allowed_params
        []
      end

      def request_params
        params.slice(*allowed_params)
      end

      def host
        SetkaIntegration::Config.host
      end

      attr_reader :params, :response
    end
  end
end
