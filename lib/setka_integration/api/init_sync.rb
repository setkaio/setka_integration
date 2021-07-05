module SetkaIntegration
  module Api
    class InitSync < V2Request
      private

      def allowed_params
        %i(token)
      end
    end
  end
end
