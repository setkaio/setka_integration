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
          expect(%i(common common_critical common_deferred).all? { |key| subject[:standalone_styles][key].is_a?(String) }).to eq true
          expect(%i(themes layouts themes_critical themes_deferred).all? { |key| subject[:standalone_styles][key].is_a?(Array) }).to eq true
          expect(%i(public_token plugins).all? { |key| subject[key].is_a?(String) }).to eq true
          expect(%i(css js).all? { |filetype| subject[:editor_files][filetype].is_a?(String) }).to eq true
          expect(%i(css json).all? { |filetype| subject[:theme_files][filetype].is_a?(String) }).to eq true
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
          is_expected.to be_kind_of String
          is_expected.to be_present
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
          expect(%i(css js).all? { |filetype| subject.public_send(filetype).is_a?(String) }).to eq true
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
          expect(%i(css json).all? { |filetype| subject.public_send(filetype).is_a?(String) }).to eq true
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
          expect(result['common']).to be_kind_of String
          expect(result['themes'].all? { |themes| themes.is_a?(String) }).to eq true
          expect(result['layouts'].all? { |layouts| layouts.is_a?(String) }).to eq true
          expect(result['common_critical']).to be_kind_of(String)
          expect(result['common_deferred']).to be_kind_of(String)
          expect(result['themes_critical'].all? { |themes_critical| themes_critical.is_a?(String) }).to eq true
          expect(result['themes_deferred'].all? { |themes_deferred| themes_deferred.is_a?(String) }).to eq true
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
