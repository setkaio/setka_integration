require 'spec_helper'
require 'setka_integration/resources/get_advanced_set'

RSpec.describe SetkaIntegration::Resources::GetAdvancedSet do
  let(:config) { SetkaIntegration::Config.new(license_key) }
  let(:license_key) { 'UYHtFJUvAs7BOkoZZiVmryaFZltecJGT' }
  let(:options) { 'amp,icons' }

  describe '.()' do
    subject { described_class.(config, options) }

    context 'with part options' do
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

  describe 'public_token' do
    subject { described_class.new(config, options).public_token }

    context 'with part options' do
      it 'return public token' do
        VCR.use_cassette 'advanced_sync/with_part_options', allow_playback_repeats: true do
          is_expected.to be_kind_of String
          is_expected.not_to be_empty
        end
      end
    end

    context 'with invalid options' do
      let(:options) { 'amp,invalid_option' }

      it 'return public token' do
        VCR.use_cassette 'advanced_sync/with_invalid_options', allow_playback_repeats: true do
          is_expected.to be_kind_of String
          is_expected.not_to be_empty
        end
      end
    end
  end

  describe 'plugins' do
    subject { described_class.new(config, options).plugins }

    context 'with part options' do
      it 'return plugins' do
        VCR.use_cassette 'advanced_sync/with_part_options', allow_playback_repeats: true do
          is_expected.to be_kind_of Array
          is_expected.not_to be_empty
        end
      end
    end

    context 'with invalid options' do
      let(:options) { 'amp,invalid_option' }

      it 'return plugins' do
        VCR.use_cassette 'advanced_sync/with_invalid_options', allow_playback_repeats: true do
          is_expected.to be_kind_of Array
          is_expected.not_to be_empty
        end
      end
    end
  end

  describe 'editor_files' do
    subject { described_class.new(config, options).editor_files }

    context 'with valid options' do
      it 'return editor files' do
        VCR.use_cassette 'advanced_sync/with_part_options', allow_playback_repeats: true do
          is_expected.to be_kind_of Array
          is_expected.not_to be_empty
        end
      end
    end

    context 'with invalid options' do
      let(:options) { 'amp,invalid_option' }

      it 'return error' do
        VCR.use_cassette 'advanced_sync/with_invalid_options', allow_playback_repeats: true do
          is_expected.to be_kind_of Array
          is_expected.not_to be_empty
        end
      end
    end
  end

  describe 'theme_files' do
    subject { described_class.new(config, options).theme_files }

    context 'with valid options' do
      it 'return theme files' do
        VCR.use_cassette 'advanced_sync/with_part_options', allow_playback_repeats: true do
          is_expected.to be_kind_of Array
          is_expected.not_to be_empty
        end
      end
    end

    context 'with invalid options' do
      let(:options) { 'amp,invalid_option' }

      it 'return error' do
        VCR.use_cassette 'advanced_sync/with_invalid_options', allow_playback_repeats: true do
          is_expected.to be_kind_of Array
          is_expected.not_to be_empty
        end
      end
    end
  end

  describe 'standalone_styles' do
    let(:result) { described_class.new(config, options).standalone_styles }

    context 'with valid options' do
      it 'return standalone styles' do
        VCR.use_cassette 'advanced_sync/with_part_options', allow_playback_repeats: true do
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

    context 'with invalid options' do
      let(:options) { 'amp,invalid_option' }

      it 'return error' do
        VCR.use_cassette 'advanced_sync/with_invalid_options', allow_playback_repeats: true do
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
  end

  describe 'amp_styles' do
    let(:result) { described_class.new(config, options).amp_styles }

    context 'with valid options' do
      it 'return amp styles' do
        VCR.use_cassette 'advanced_sync/with_part_options', allow_playback_repeats: true do
          expect(result.dig('common').all? { |common| common.is_a?(String) }).to eq true
          expect(result.dig('themes').all? { |themes| themes.is_a?(String) }).to eq true
          expect(result.dig('layouts').all? { |layouts| layouts.is_a?(String) }).to eq true
        end
      end
    end

    context 'with invalid options' do
      let(:options) { 'amp,invalid_option' }

      it 'return amp styles' do
        VCR.use_cassette 'advanced_sync/with_invalid_options', allow_playback_repeats: true do
          expect(result.dig('common').all? { |common| common.is_a?(String) }).to eq true
          expect(result.dig('themes').all? { |themes| themes.is_a?(String) }).to eq true
          expect(result.dig('layouts').all? { |layouts| layouts.is_a?(String) }).to eq true
        end
      end
    end
  end

  describe 'fonts' do
    subject { described_class.new(config, options).fonts }

    context 'with valid options' do
      it 'return nothing' do
        VCR.use_cassette 'advanced_sync/with_part_options', allow_playback_repeats: true do
          is_expected.to be_nil
        end
      end
    end

    context 'with invalid options' do
      let(:options) { 'amp,invalid_option' }

      it 'return nothing' do
        VCR.use_cassette 'advanced_sync/with_invalid_options', allow_playback_repeats: true do
          is_expected.to be_nil
        end
      end
    end
  end

  describe 'icons' do
    subject { described_class.new(config, options).icons }

    context 'with valid options' do
      it 'return nothing' do
        VCR.use_cassette 'advanced_sync/with_part_options', allow_playback_repeats: true do
          is_expected.to be_kind_of Array
          is_expected.to be_empty
        end
      end
    end

    context 'with invalid options' do
      let(:options) { 'amp,invalid_option' }

      it 'return nothing' do
        VCR.use_cassette 'advanced_sync/with_invalid_options', allow_playback_repeats: true do
          is_expected.to be_nil
        end
      end
    end
  end
end
