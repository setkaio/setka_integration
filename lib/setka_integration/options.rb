module SetkaIntegration
  class Options
    class << self
      def files(opts)
        SetkaIntegration::Resources::GetAdvancedSet.(SetkaIntegration::Config, opts)
      end
    end
  end
end
