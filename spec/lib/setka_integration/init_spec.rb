require 'spec_helper'
require 'setka_integration/init'

RSpec.describe SetkaIntegration::Init do
  subject { described_class.files }

  before do
    SetkaIntegration::Config.configure(
      license_key: license_key
    )
  end

  describe '#files' do
    context 'with valid token' do
      let(:license_key) { 'UYHtFJUvAs7BOkoZZiVmryaFZltecJGT' }

      it 'returns Setka editor files' do
        VCR.use_cassette 'init_sync/with_valid_token', allow_playback_repeats: true do
          expect(%i(public_token plugins editor_files theme_files standalone_styles).all? { |key| subject[key].is_a?(String) })
        end
      end
    end

    context 'with invalid token' do
      let(:license_key) { 'wrong token' }

      it 'return error' do
        VCR.use_cassette 'init_sync/with_invalid_token', allow_playback_repeats: true do
          is_expected.to eq 'Not authorized!'
        end
      end
    end
  end
end
