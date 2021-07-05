require 'uri'
require 'net/http'
require 'byebug'

require 'active_support/core_ext/hash'

require 'setka_integration/api/v2_request'
require 'setka_integration/resources/get_resource'
require "setka_integration/config"
require "setka_integration/version"

module SetkaIntegration
  class << self
    def configure(config = {})
      SetkaIntegration::Config.configure(config)
    end
  end
end
