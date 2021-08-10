module SetkaIntegration
  module Resources
    class GetInitSet < GetResource
      private

      def hash_keys
        %i(public_token plugins editor_files theme_files standalone_styles)
      end

      def request
        @request ||= SetkaIntegration::Api::InitSync.(params)
      end

      def params
        { token: config.license_key }
      end
    end
  end
end
