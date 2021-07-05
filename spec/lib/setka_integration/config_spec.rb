require 'spec_helper'
require 'setka_integration/config'

RSpec.describe SetkaIntegration::Config do
  describe '#configure' do
    let(:config) { { license_key: 'license_key' } }

    subject { described_class.configure(config) }

    it { expect { subject }.to change(described_class, :license_key).to 'license_key' }
  end
end
