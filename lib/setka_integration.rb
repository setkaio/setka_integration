require "setka_integration/version"
require "setka_integration/config"

module SetkaIntegration
  class << self
    def configure(config = {})
      SetkaIntegration::Config.configure(config)
    end
  end
end
