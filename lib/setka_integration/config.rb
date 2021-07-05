module SetkaIntegration
  class Config
    attr_reader :license_key, :options, :select

    def initialize(license_key, options: {}, select: {})
      @license_key = license_key
      @options = options
      @select = select
    end
  end
end
