require 'spec_helper'
require 'setka_integration/config'

RSpec.describe SetkaIntegration::Config do
  describe '#configure' do
    let(:config) { { license_key: license_key, host: host } }
    let(:license_key) { 'license_key' }
    let(:host) { 'host' }

    subject { described_class.configure(config) }

    it 'change config attributes' do
      expect { subject }.to change(described_class, :license_key).to(license_key)
      .and change(described_class, :host).to(host)
    end
  end
end
