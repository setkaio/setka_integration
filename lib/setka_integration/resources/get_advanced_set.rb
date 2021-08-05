module SetkaIntegration
  module Resources
    class GetAdvancedSet < GetResource
      def public_token
        response_data do
          request.body['public_token']
        end
      end

      def plugins
        response_data do
          request.body['plugins']&.map { |plugin| plugin['url'] }
        end
      end

      def editor_files
        response_data do
          request.body['editor_files']&.map { |editor_file| editor_file['url'] }
        end
      end

      def theme_files
        response_data do
          request.body['theme_files']&.map { |theme_file| theme_file['url'] }
        end
      end

      def standalone_styles
        response_data do
          request.body['standalone_styles']&.inject({}) do |hash, (key, group)|
            hash.merge({ key => group.map { |group_file| group_file['url'] } })
          end
        end
      end

      def amp_styles
        if options.include?(:amp)
          response_data do
            request.body['amp_styles']&.inject({}) do |hash, (key, group)|
              hash.merge({ key => group.map { |group_file| group_file['url'] } })
            end
          end
        end
      end

      def fonts
        if options.include?(:fonts)
          response_data do
            request.body['fonts']&.map { |font_file| font_file['url'] }
          end
        end
      end

      def icons
        if options.include?(:icons)
          response_data do
            request.body['icons']&.map { |icon_file| icon_file['url'] }
          end
        end
      end

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
