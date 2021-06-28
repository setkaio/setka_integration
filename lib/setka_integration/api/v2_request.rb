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
        uri.query = URI.encode_www_form(request_params)

        res = Net::HTTP.get_response(uri)
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

      def request_params
        raise NotImplementedError
      end

      attr_accessor :params
    end
  end
end
