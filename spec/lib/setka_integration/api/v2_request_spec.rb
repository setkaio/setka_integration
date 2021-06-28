require "setka_integration/api/v2_request"

RSpec.describe SetkaIntegration::Api::V2Request do
  describe '.()' do
    it { expect{ described_class.() }.to raise_error(NotImplementedError) }
  end
end
