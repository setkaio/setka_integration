module SetkaIntegration
  class Select
    class << self
      def files(opts)
        select_files_set(opts)
      end

      def all
        opts = 'plugins,editor,theme,standalone,amp,fonts,icons'
        select_files_set(opts)
      end

      def public_token
        opts = ''
        select_files_set(opts)
      end

      def plugins
        opts = 'plugins'
        select_files_set(opts)
      end

      def editor_files
        opts = 'editor'
        select_files_set(opts)
      end

      def theme_files
        opts = 'theme'
        select_files_set(opts)
      end

      def standalone_styles
        opts = 'standalone'
        select_files_set(opts)
      end

      def amp_styles
        opts = 'amp'
        select_files_set(opts)
      end

      def fonts
        opts = 'fonts'
        select_files_set(opts)
      end

      def icons
        opts = 'icons'
        select_files_set(opts)
      end

      private

      def select_files_set(opts)
        SetkaIntegration::Resources::SelectFilesSet.(SetkaIntegration::Config, opts)
      end
    end
  end
end
