module SetkaIntegration
  class Init
    class << self
      def files
        SetkaIntegration::Resources::GetInitSet.(SetkaIntegration::Config)
      end
    end
  end
end
