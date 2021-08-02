require 'uri'
require 'net/http'
require 'byebug'

require 'active_support/core_ext/hash'

require 'setka_integration/api/v2_request'
require 'setka_integration/api/init_sync'
require 'setka_integration/api/advanced_sync'
require 'setka_integration/api/select_files_sync'

require 'setka_integration/resources/get_resource'
require 'setka_integration/resources/get_init_set'
require 'setka_integration/resources/get_advanced_set'
require 'setka_integration/resources/select_files_set'

require "setka_integration/config"
require "setka_integration/init"
require "setka_integration/options"
require "setka_integration/select"

require "setka_integration/error"
require "setka_integration/version"

module SetkaIntegration
  class << self
    def configure(config = {})
      SetkaIntegration::Config.configure(config)
    end
  end
end
