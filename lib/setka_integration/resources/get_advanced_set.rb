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
          request.body['plugins'][0]['url']
        end
      end

      def editor_files
        response_data do
          filetypes = request.body['editor_files']&.map { |h| h['filetype'].to_sym }&.uniq
          return if filetypes.blank?

          response_struct = Struct.new(*filetypes)

          urls = filetypes.map do |filetype|
            request.body['editor_files'].find { |file| file['filetype'] == filetype.to_s }['url']
          end

          response_struct.new(*urls)
        end
      end

      def theme_files
        response_data do
          filetypes = request.body['theme_files']&.map { |h| h['filetype'].to_sym }&.uniq
          return if filetypes.blank?

          response_struct = Struct.new(*filetypes)

          urls = filetypes.map do |filetype|
            request.body['theme_files'].find { |file| file['filetype'] == filetype.to_s }['url']
          end

          response_struct.new(*urls)
        end
      end

      def standalone_styles
        response_data do
          response_hash = request.body['standalone_styles']&.inject({}) do |hash, (key, group)|
            if group.count > 1
              hash.merge({ key => group.map { |group_file| group_file['url'] } })
            else
              hash.merge({ key => group[0]['url'] })
            end
          end.symbolize_keys

          response_struct = Struct.new(*response_hash.keys)
          response_struct.new(*response_hash.values_at(*response_struct.members))
        end
      end

      def amp_styles
        response_data do
          response_hash = request.body['standalone_styles']&.inject({}) do |hash, (key, group)|
            if group.count > 1
              hash.merge({ key => group.map { |group_file| group_file['url'] } })
            else
              hash.merge({ key => group[0]['url'] })
            end
          end.symbolize_keys

          response_struct = Struct.new(*response_hash.keys)
          response_struct.new(*response_hash.values_at(*response_struct.members))
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
