module SetkaIntegration
  class Select
    class << self
      def files
        SetkaIntegration::Resources::SelectFilesSet.(SetkaIntegration::Config)
      end
    end
  end
end
