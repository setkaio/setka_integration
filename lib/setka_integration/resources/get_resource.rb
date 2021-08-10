module SetkaIntegration
  module Resources
    class GetResource
      attr_reader :config, :opts

      def initialize(config, opts = '')
        @config = config
        @opts = opts
      end

      def call
        request.success? ? full_set : error
      end

      class << self
        def call(*args)
          new(*args).call
        end
      end

      def public_token
        response_data do
          request.body['public_token']
        end
      end

      def plugins
        response_data do
          return if request.body['plugins'].blank?
          request.body['plugins'][0]['url']
        end
      end

      def editor_files
        response_data do
          return if request.body['editor_files'].blank?
          filetypes = request.body['editor_files'].map { |h| h['filetype'].to_sym }.uniq

          response_struct = Struct.new(*filetypes)

          urls = filetypes.map do |filetype|
            request.body['editor_files'].find { |file| file['filetype'] == filetype.to_s }['url']
          end

          response_struct.new(*urls)
        end
      end

      def theme_files
        response_data do
          return if request.body['theme_files'].blank?
          filetypes = request.body['theme_files'].map { |h| h['filetype'].to_sym }.uniq

          response_struct = Struct.new(*filetypes)

          urls = filetypes.map do |filetype|
            request.body['theme_files'].find { |file| file['filetype'] == filetype.to_s }['url']
          end

          response_struct.new(*urls)
        end
      end

      def standalone_styles
        response_data do
          return if request.body['standalone_styles'].blank?
          response_hash = request.body['standalone_styles'].inject({}) do |hash, (key, group)|
            if group.count > 1
              hash.merge({ key => group.map { |group_file| group_file['url'] } })
            else
              hash.merge({ key => group[0]['url'] })
            end
          end

          response_hash.symbolize_keys!
          response_struct = Struct.new(*response_hash.keys)
          response_struct.new(*response_hash.values_at(*response_struct.members))
        end
      end

      def amp_styles
        response_data do
          return if request.body['amp_styles'].blank?
          response_hash = request.body['amp_styles'].inject({}) do |hash, (key, group)|
            if group.count > 1
              hash.merge({ key => group.map { |group_file| group_file['url'] } })
            else
              hash.merge({ key => group[0]['url'] })
            end
          end

          response_hash.symbolize_keys!
          response_struct = Struct.new(*response_hash.keys)
          response_struct.new(*response_hash.values_at(*response_struct.members))
        end
      end

      def fonts
        if options.include?(:fonts)
          response_data do
            return [] if request.body['fonts'].blank?
            request.body['fonts'].map { |font_file| font_file['url'] }
          end
        end
      end

      def icons
        if options.include?(:icons)
          response_data do
            return [] if request.body['icons'].blank?
            request.body['icons'].map { |icon_file| icon_file['url'] }
          end
        end
      end

      private

      def struct
        Struct.new(*hash_keys)
      end

      def hash_data
        hash_keys.inject({}) do |hash, key|
          hash.merge({ key => public_send(key) })
        end
      end

      def full_set
        struct.new(*hash_data.values)
      end

      def error
        raise ::SetkaIntegration::Error, request.body['error']
      end

      def request
        raise NotImplementedError
      end

      def response_data
        request.success? ? (yield if block_given?) : error
      end
    end
  end
end
