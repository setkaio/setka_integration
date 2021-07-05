require 'active_support/core_ext/hash'

module SetkaIntegration
  class Config
    attr_reader :license_key, :options, :select

    def initialize(license_key, options: {}, select: {})
      @license_key = license_key
      @options = options
      @select = select
    end

    class << self
      attr_reader :license_key, :options, :select

      def configure(config)
        config.stringify_keys!

        @license_key = config['license_key']
        @options = config['options']
        @select = config['select']
      end
    end
  end
end
