require 'spec_helper'
require 'setka_integration/resources/get_advanced_set'

RSpec.describe SetkaIntegration::Resources::GetAdvancedSet do
  let(:config) { SetkaIntegration::Config }
  let(:license_key) { 'UYHtFJUvAs7BOkoZZiVmryaFZltecJGT' }
  let(:options) { 'amp,icons' }

  before do
    SetkaIntegration::Config.configure(
      license_key: license_key
    )
  end

  describe '.()' do
    subject { described_class.(config, options) }

    context 'with part options' do
      it 'returns Setka editor files' do
        VCR.use_cassette 'advanced_sync/with_part_options', allow_playback_repeats: true do
          expect(%i(common common_critical common_deferred).all? { |key| subject[:standalone_styles][key].is_a?(String) }).to eq true
          expect(subject[:amp_styles][:common]).to be_kind_of String
          expect(%i(themes layouts).all? { |key| subject[:amp_styles][key].is_a?(Array) }).to eq true
          expect(%i(themes layouts themes_critical themes_deferred).all? { |key| subject[:standalone_styles][key].is_a?(Array) }).to eq true
          expect(%i(public_token plugins).all? { |key| subject[key].is_a?(String) }).to eq true
          expect(%i(css js).all? { |filetype| subject[:editor_files][filetype].is_a?(String) }).to eq true
          expect(%i(css json).all? { |filetype| subject[:theme_files][filetype].is_a?(String) }).to eq true
          expect(subject[:icons]).to be_empty
          expect(subject[:fonts]).to be_nil
        end
      end
    end

    context 'with invalid options' do
      let(:options) { 'amp,invalid_option' }

      it 'return Setka editor files' do
        VCR.use_cassette 'advanced_sync/with_invalid_options', allow_playback_repeats: true do
          expect(%i(public_token plugins).all? { |key| subject[key].is_a?(String) }).to eq true
          expect(%i(themes layouts themes_critical themes_deferred).all? { |key| subject[:standalone_styles][key].is_a?(Array) }).to eq true
          expect(subject[:amp_styles][:common]).to be_kind_of String
          expect(%i(themes layouts).all? { |key| subject[:amp_styles][key].is_a?(Array) }).to eq true
          expect(%i(css js).all? { |filetype| subject[:editor_files][filetype].is_a?(String) }).to eq true
          expect(%i(css json).all? { |filetype| subject[:theme_files][filetype].is_a?(String) }).to eq true
          expect(%i(icons fonts).all? { |key| subject[key].nil? }).to eq true
        end
      end
    end

    context 'with invalid token' do
      let(:license_key) { 'wrong token' }

      it 'return error' do
        VCR.use_cassette 'advanced_sync/with_invalid_token', allow_playback_repeats: true do
          expect { subject }.to raise_error(SetkaIntegration::Error, 'Not authorized!')
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
          is_expected.to be_kind_of String
          is_expected.not_to be_empty
        end
      end
    end

    context 'with invalid options' do
      let(:options) { 'amp,invalid_option' }

      it 'return plugins' do
        VCR.use_cassette 'advanced_sync/with_invalid_options', allow_playback_repeats: true do
          is_expected.to be_kind_of String
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
          expect(%i(css js).all? { |filetype| subject[filetype].is_a?(String) }).to eq true
        end
      end
    end

    context 'with invalid options' do
      let(:options) { 'amp,invalid_option' }

      it 'return editor files' do
        VCR.use_cassette 'advanced_sync/with_invalid_options', allow_playback_repeats: true do
          expect(%i(css js).all? { |filetype| subject[filetype].is_a?(String) }).to eq true
        end
      end
    end
  end

  describe 'theme_files' do
    subject { described_class.new(config, options).theme_files }

    context 'with valid options' do
      it 'return theme files' do
        VCR.use_cassette 'advanced_sync/with_part_options', allow_playback_repeats: true do
          expect(%i(css json).all? { |filetype| subject.public_send(filetype).is_a?(String) }).to eq true
        end
      end
    end

    context 'with invalid options' do
      let(:options) { 'amp,invalid_option' }

      it 'return theme files' do
        VCR.use_cassette 'advanced_sync/with_invalid_options', allow_playback_repeats: true do
          expect(%i(css json).all? { |filetype| subject.public_send(filetype).is_a?(String) }).to eq true
        end
      end
    end
  end

  describe 'standalone_styles' do
    let(:result) { described_class.new(config, options).standalone_styles }

    context 'with valid options' do
      it 'return standalone styles' do
        VCR.use_cassette 'advanced_sync/with_part_options', allow_playback_repeats: true do
          expect(result['common']).to be_kind_of String
          expect(result['themes'].all? { |themes| themes.is_a?(String) }).to eq true
          expect(result['layouts'].all? { |layouts| layouts.is_a?(String) }).to eq true
          expect(result['common_critical']).to be_kind_of String
          expect(result['common_deferred']).to be_kind_of String
          expect(result['themes_critical'].all? { |themes_critical| themes_critical.is_a?(String) }).to eq true
          expect(result['themes_deferred'].all? { |themes_deferred| themes_deferred.is_a?(String) }).to eq true
        end
      end
    end

    context 'with invalid options' do
      let(:options) { 'amp,invalid_option' }

      it 'return standalone styles' do
        VCR.use_cassette 'advanced_sync/with_invalid_options', allow_playback_repeats: true do
          expect(result['common']).to be_kind_of String
          expect(result['themes'].all? { |themes| themes.is_a?(String) }).to eq true
          expect(result['layouts'].all? { |layouts| layouts.is_a?(String) }).to eq true
          expect(result['common_critical']).to be_kind_of String
          expect(result['common_deferred']).to be_kind_of String
          expect(result['themes_critical'].all? { |themes_critical| themes_critical.is_a?(String) }).to eq true
          expect(result['themes_deferred'].all? { |themes_deferred| themes_deferred.is_a?(String) }).to eq true
        end
      end
    end
  end

  describe 'amp_styles' do
    let(:result) { described_class.new(config, options).amp_styles }

    context 'with valid options' do
      it 'return amp styles' do
        VCR.use_cassette 'advanced_sync/with_part_options', allow_playback_repeats: true do
          expect(result['common']).to be_kind_of String
          expect(result['themes'].all? { |themes| themes.is_a?(String) }).to eq true
          expect(result['layouts'].all? { |layouts| layouts.is_a?(String) }).to eq true
        end
      end
    end

    context 'with invalid options' do
      let(:options) { 'amp,invalid_option' }

      it 'return amp styles' do
        VCR.use_cassette 'advanced_sync/with_invalid_options', allow_playback_repeats: true do
          expect(result['common']).to be_kind_of String
          expect(result['themes'].all? { |themes| themes.is_a?(String) }).to eq true
          expect(result['layouts'].all? { |layouts| layouts.is_a?(String) }).to eq true
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
