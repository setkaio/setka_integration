module SetkaIntegration
  class Select
    class << self
      def all
        opts = 'plugins,editor,theme,standalone,amp,fonts,icons'
        files(opts)
      end

      def public_token
        opts = ''
        files(opts)[:public_token]
      end

      def plugins
        opts = 'plugins'
        files(opts)[:plugins]
      end

      def editor_files
        opts = 'editor'
        files(opts)[:editor_files]
      end

      def theme_files
        opts = 'theme'
        files(opts)[:theme_files]
      end

      def amp_styles
        opts = 'amp'
        files(opts)[:amp_styles]
      end

      def standalone_styles
        opts = 'standalone'
        files(opts)[:standalone_styles]
      end

      def icons
        opts = 'icons'
        files(opts)[:icons]
      end

      def fonts
        opts = 'fonts'
        files(opts)[:fonts]
      end

      def files(opts)
        SetkaIntegration::Resources::SelectFilesSet.(SetkaIntegration::Config, opts)
      end
    end
  end
end
