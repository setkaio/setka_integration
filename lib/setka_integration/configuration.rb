module SetkaIntegration
  class Configuration
    attr_reader :license_key, :options

    def initialize(license_key, options = {})
      @license_key = license_key
      @options = options
    end
  end
end
