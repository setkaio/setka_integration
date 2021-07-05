require 'spec_helper'
require 'setka_integration/config'

RSpec.describe SetkaIntegration::Config do
  describe '#configure' do
    let(:config) do
      {
        license_key: 'license_key',
        options: 'config_options',
        select: 'config_select'
      }
    end

    subject { described_class.configure(config) }

    it { expect { subject }.to change(described_class, :license_key).to 'license_key' }
  end
end
