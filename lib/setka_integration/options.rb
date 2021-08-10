module SetkaIntegration
  class Options
    class << self
      def public_token
        files('public_token')[:public_token]
      end

      def plugins
        files('plugins')[:plugins]
      end

      def editor_files
        files('editor')[:editor_files]
      end

      def theme_files
        files('theme')[:theme_files]
      end

      def amp_styles
        files('amp')[:amp_styles]
      end

      def standalone_styles
        files('standalone')[:standalone_styles]
      end

      def icons
        files('icons')[:icons]
      end

      def fonts
        files('fonts')[:fonts]
      end

      def files(opts)
        SetkaIntegration::Resources::GetAdvancedSet.(SetkaIntegration::Config, opts)
      end
    end
  end
end
