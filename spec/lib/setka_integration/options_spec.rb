require 'spec_helper'
require 'setka_integration/options'

RSpec.describe SetkaIntegration::Options do
  subject { described_class.files(options) }

  let(:license_key) { 'UYHtFJUvAs7BOkoZZiVmryaFZltecJGT' }
  let(:options) { 'amp,icons' }

  before do
    SetkaIntegration::Config.configure(
      license_key: license_key,
      options: options
    )
  end

  describe '#files' do
    context 'with valid token' do
      it 'returns Setka editor files' do
        VCR.use_cassette 'advanced_sync/with_part_options', allow_playback_repeats: true do
          expect(subject[:public_token]).not_to be_empty
          expect(%i(plugins editor_files theme_files standalone_styles amp_styles icons).all? { |key| !subject[key].compact.empty? })
          expect(%i(fonts).all? { |key| subject[key].nil? }).to eq true
        end
      end
    end

    context 'with invalid options' do
      let(:options) { 'amp,invalid_option' }

      it 'return error' do
        VCR.use_cassette 'advanced_sync/with_invalid_options', allow_playback_repeats: true do
          expect(subject[:public_token]).not_to be_empty
          expect(%i(plugins editor_files theme_files standalone_styles amp_styles).all? { |key| !subject[key].compact.empty? })
          expect(%i(icons fonts).all? { |key| subject[key].nil? }).to eq true
        end
      end
    end

    context 'with invalid token' do
      let(:license_key) { 'wrong token' }

      it 'return error' do
        VCR.use_cassette 'advanced_sync/with_invalid_token', allow_playback_repeats: true do
          is_expected.to eq 'Not authorized!'
        end
      end
    end
  end
end
