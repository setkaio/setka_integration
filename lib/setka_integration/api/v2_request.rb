require 'uri'
require 'net/http'

module SetkaIntegration
  module Api
    class V2Request
      def initialize(params = {})
        @params = params
      end

      def call
        uri = URI(endpoint)
        uri.query = URI.encode_www_form(request_params) unless allowed_params.empty?

        Net::HTTP.get_response(uri)
      end

      class << self
        def call(*args)
          new(args).()
        end
      end

      private

      def endpoint
        'https://editor.setka.io/api/v2/integration'
      end

      def allowed_params
        {}
      end

      def request_params
        params.slice(*allowed_params.keys)
      end

      attr_accessor :params
    end
  end
end
