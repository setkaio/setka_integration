module SetkaIntegration
  class Options
    class << self
      def files
        SetkaIntegration::Resources::GetAdvancedSet.(SetkaIntegration::Config)
      end
    end
  end
end
