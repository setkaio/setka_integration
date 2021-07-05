module SetkaIntegration
  class Options
    class << self
      def files(options)
        SetkaIntegration::Resources::GetAdvancedSet.(SetkaIntegration::Config, options)
      end
    end
  end
end
