require 'setka_integration/api/v2_request'

module SetkaIntegration
  module Api
    class SelectFilesSync < V2Request
      private

      def allowed_params
        %i(token select)
      end
    end
  end
end
