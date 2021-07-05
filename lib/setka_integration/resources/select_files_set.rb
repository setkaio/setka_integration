require 'setka_integration/config'
require 'setka_integration/resources/get_resource'

module SetkaIntegration
  module Resources
    class SelectFilesSet < GetResource
      def public_token
        response_data do
          request.body['public_token']
        end
      end

      def plugins
        if select.include?(:plugins)
          response_data do
            request.body['plugins'].map { |plugin| plugin['url'] }
          end
        end
      end

      def editor_files
        if select.include?(:editor)
          response_data do
            request.body['editor_files'].map { |editor_file| editor_file['url'] }
          end
        end
      end

      def theme_files
        if select.include?(:theme)
          response_data do
            request.body['theme_files'].map { |theme_file| theme_file['url'] }
          end
        end
      end

      def standalone_styles
        if select.include?(:standalone)
          response_data do
            request.body['standalone_styles'].inject({}) do |hash, (key, group)|
              hash.merge({ key => group.map{ |group_file| group_file['url'] } })
            end
          end
        end
      end

      def amp_styles
        if select.include?(:amp)
          response_data do
            request.body['amp_styles'].inject({}) do |hash, (key, group)|
              hash.merge({ key => group.map{ |group_file| group_file['url'] } })
            end
          end
        end
      end

      def fonts
        if select.include?(:fonts)
          response_data do
            request.body['fonts'].map { |font_file| font_file['url'] }
          end
        end
      end

      def icons
        if select.include?(:icons)
          response_data do
            request.body['icons'].map { |icon_file| icon_file['url'] }
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
          standalone_styles: standalone_styles,
          amp_styles: amp_styles,
          fonts: fonts,
          icons: icons
        }.compact
      end

      def request
        @request ||= SetkaIntegration::Api::SelectFilesSync.(params)
      end

      def params
        {
          token: config.license_key,
          select: config.select
        }
      end

      def select
        @select ||= config.select.split(',').map(&:to_sym)
      end
    end
  end
end
