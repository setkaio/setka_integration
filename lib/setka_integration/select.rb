module SetkaIntegration
  class Select
    class << self
      def files(select)
        SetkaIntegration::Resources::SelectFilesSet.(SetkaIntegration::Config, select)
      end
    end
  end
end
