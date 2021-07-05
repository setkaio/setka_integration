module SetkaIntegration
  class Config
    attr_reader :license_key

    def initialize(license_key)
      @license_key = license_key
    end

    class << self
      attr_reader :license_key

      def configure(config)
        config.stringify_keys!
        @license_key = config['license_key']
      end
    end
  end
end
