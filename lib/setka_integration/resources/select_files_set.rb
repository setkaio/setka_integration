module SetkaIntegration
  module Resources
    class SelectFilesSet < GetResource
      def plugins
        if options.include?(:plugins)
          super
        end
      end

      def editor_files
        if options.include?(:editor)
          super
        end
      end

      def theme_files
        if options.include?(:theme)
          super
        end
      end

      def standalone_styles
        if options.include?(:standalone)
          super
        end
      end

      def amp_styles
        if options.include?(:amp)
          super
        end
      end

      def fonts
        if options.include?(:fonts)
          super
        end
      end

      def icons
        if options.include?(:icons)
          super
        end
      end

      private

      def hash_keys
        %i(public_token plugins editor_files theme_files standalone_styles amp_styles fonts icons)
      end

      def request
        @request ||= SetkaIntegration::Api::SelectFilesSync.(params)
      end

      def params
        {
          token: config.license_key,
          select: opts
        }
      end

      def options
        @options ||= opts.split(',').map(&:to_sym)
      end
    end
  end
end
