require 'setka_integration/api/v2_request'

module SetkaIntegration
  module Api
    class AdvancedSync < V2Request
      private

      def allowed_params
        %i(token options)
      end
    end
  end
end
