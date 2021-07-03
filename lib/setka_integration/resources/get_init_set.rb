require 'setka_integration/configuration'
require 'setka_integration/resources/get_resource'

module SetkaIntegration
  module Resources
    class GetInitSet < GetResource
      def call
        request.success? ? full_set : error
      end

      def public_token
        response_data do
          request.body['public_token']
        end
      end

      def plugins
        response_data do
          request.body['plugins'].map { |plugin| plugin['url'] }
        end
      end

      def editor_files
        response_data do
          request.body['editor_files'].map { |editor_file| editor_file['url'] }
        end
      end

      def theme_files
        response_data do
          request.body['theme_files'].map { |theme_file| theme_file['url'] }
        end
      end

      def standalone_styles
        response_data do
          request.body['standalone_styles'].inject({}) do |hash, (key, group)|
            hash.merge({ key => group.map{ |group_file| group_file['url'] } })
          end
        end
      end

      private

      def full_set
        {
          public_token: public_token,
          plugins: plugins,
          editor_files: editor_files,
          theme_files: theme_files,
          standalone_styles: standalone_styles
        }
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

