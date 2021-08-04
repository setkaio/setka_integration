require 'spec_helper'
require 'setka_integration/resources/get_init_set'

RSpec.describe SetkaIntegration::Resources::GetInitSet do
  let(:config) { SetkaIntegration::Config }
  let(:license_key) { 'UYHtFJUvAs7BOkoZZiVmryaFZltecJGT' }

  before do
    SetkaIntegration::Config.configure(
      license_key: license_key
    )
  end

  describe '.()' do
    subject { described_class.(config) }

    context 'with valid token' do
      it 'returns Setka editor files' do
        VCR.use_cassette 'init_sync/with_valid_token', allow_playback_repeats: true do
          expect(subject[:public_token]).to be_kind_of String
          expect(subject[:standalone_styles]).to be_kind_of Hash
          expect(%i(plugins editor_files theme_files).all? { |key| subject[key].is_a?(Array) }).to eq true
        end
      end
    end

    context 'with invalid token' do
      let(:license_key) { 'wrong token' }

      it 'return error' do
        VCR.use_cassette 'init_sync/with_invalid_token', allow_playback_repeats: true do
          expect { subject }.to raise_error(SetkaIntegration::Error, 'Not authorized!')
        end
      end
    end
  end

  describe 'public_token' do
    subject { described_class.new(config).public_token }

    context 'with valid token' do
      it 'return public token' do
        VCR.use_cassette 'init_sync/with_valid_token', allow_playback_repeats: true do
          is_expected.to be_kind_of String
          is_expected.not_to be_empty
        end
      end
    end

    context 'with invalid token' do
      let(:license_key) { 'wrong token' }

      it 'return error' do
        VCR.use_cassette 'init_sync/with_invalid_token', allow_playback_repeats: true do
          expect { subject }.to raise_error(SetkaIntegration::Error, 'Not authorized!')
        end
      end
    end
  end

  describe 'plugins' do
    subject { described_class.new(config).plugins }

    context 'with valid token' do
      it 'return plugins' do
        VCR.use_cassette 'init_sync/with_valid_token', allow_playback_repeats: true do
          is_expected.to be_kind_of Array
          is_expected.not_to be_empty
        end
      end
    end

    context 'with invalid token' do
      let(:license_key) { 'wrong token' }

      it 'return error' do
        VCR.use_cassette 'init_sync/with_invalid_token', allow_playback_repeats: true do
          expect { subject }.to raise_error(SetkaIntegration::Error, 'Not authorized!')
        end
      end
    end
  end

  describe 'editor_files' do
    subject { described_class.new(config).editor_files }

    context 'with valid token' do
      it 'return editor files' do
        VCR.use_cassette 'init_sync/with_valid_token', allow_playback_repeats: true do
          is_expected.to be_kind_of Array
          is_expected.not_to be_empty
        end
      end
    end

    context 'with invalid token' do
      let(:license_key) { 'wrong token' }

      it 'return error' do
        VCR.use_cassette 'init_sync/with_invalid_token', allow_playback_repeats: true do
          expect { subject }.to raise_error(SetkaIntegration::Error, 'Not authorized!')
        end
      end
    end
  end

  describe 'theme_files' do
    subject { described_class.new(config).theme_files }

    context 'with valid token' do
      it 'return theme files' do
        VCR.use_cassette 'init_sync/with_valid_token', allow_playback_repeats: true do
          is_expected.to be_kind_of Array
          is_expected.not_to be_empty
        end
      end
    end

    context 'with invalid token' do
      let(:license_key) { 'wrong token' }

      it 'return error' do
        VCR.use_cassette 'init_sync/with_invalid_token', allow_playback_repeats: true do
          expect { subject }.to raise_error(SetkaIntegration::Error, 'Not authorized!')
        end
      end
    end
  end

  describe 'standalone_styles' do
    let(:result) { described_class.new(config).standalone_styles }

    context 'with valid token' do
      it 'return standalone styles' do
        VCR.use_cassette 'init_sync/with_valid_token', allow_playback_repeats: true do
          expect(result.dig('common').all? { |common| common.is_a?(String) }).to eq true
          expect(result.dig('themes').all? { |themes| themes.is_a?(String) }).to eq true
          expect(result.dig('layouts').all? { |layouts| layouts.is_a?(String) }).to eq true
          expect(result.dig('common_critical').all? { |common_critical| common_critical.is_a?(String) }).to eq true
          expect(result.dig('common_deferred').all? { |common_deferred| common_deferred.is_a?(String) }).to eq true
          expect(result.dig('themes_critical').all? { |themes_critical| themes_critical.is_a?(String) }).to eq true
          expect(result.dig('themes_deferred').all? { |themes_deferred| themes_deferred.is_a?(String) }).to eq true
        end
      end
    end

    context 'with invalid token' do
      let(:license_key) { 'wrong token' }

      it 'return error' do
        VCR.use_cassette 'init_sync/with_invalid_token', allow_playback_repeats: true do
          expect { result }.to raise_error(SetkaIntegration::Error, 'Not authorized!')
        end
      end
    end
  end
end
