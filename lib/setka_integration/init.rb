module SetkaIntegration
  class Init
    class << self
      delegate :public_token, :plugins, :editor_files, :theme_files, :standalone_styles, to: :files

      def files
        SetkaIntegration::Resources::GetInitSet.(SetkaIntegration::Config)
      end
    end
  end
end
