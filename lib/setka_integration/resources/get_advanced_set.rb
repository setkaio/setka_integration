module SetkaIntegration
  module Resources
    class GetAdvancedSet < GetResource
      private

      def hash_keys
        %i(public_token plugins editor_files theme_files standalone_styles amp_styles fonts icons)
      end

      def request
        @request ||= SetkaIntegration::Api::AdvancedSync.(params)
      end

      def params
        {
          token: config.license_key,
          options: opts
        }
      end

      def options
        @options ||= opts.split(',').map(&:to_sym)
      end
    end
  end
end
