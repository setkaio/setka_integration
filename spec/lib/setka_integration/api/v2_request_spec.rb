require 'spec_helper'
require 'setka_integration/api/v2_request'
require 'json'

RSpec.describe SetkaIntegration::Api::V2Request do
  describe '.()' do
    let(:response) do
      double({
        code: 200,
        body: { key1: 'value1', key2: 'value2' }.to_json
      })
    end

    before do
      allow(Net::HTTP).to receive(:get_response).and_return response
    end

    context 'with params' do
      let(:params) do
        { param1: 'value1', params2: 'value2' }
      end

      it { expect(described_class.(params).body).to eq response.body }
    end

    context 'without params' do
      it { expect(described_class.()).to eq response }
    end
  end
end
