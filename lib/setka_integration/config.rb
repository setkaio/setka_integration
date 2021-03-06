module SetkaIntegration
  class Config
    class << self
      attr_reader :license_key, :host

      def configure(config)
        config.stringify_keys!

        @license_key = config['license_key']
        @host = config['host'] || production_host
      end

      private

      def production_host
        'https://editor.setka.io'
      end
    end
  end
end
