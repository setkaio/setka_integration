module SetkaIntegration
  class Configuration
    attr_accessor :license_key

    def initialize(license_key)
      @license_key = license_key
    end
  end
end
