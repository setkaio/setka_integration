require 'spec_helper'
require 'setka_integration/resources/select_files_set'

RSpec.describe SetkaIntegration::Resources::SelectFilesSet do
  let(:config) { SetkaIntegration::Config.new(license_key) }
  let(:license_key) { 'UYHtFJUvAs7BOkoZZiVmryaFZltecJGT' }
  let(:select) { 'plugins,amp' }

  describe '.()' do
    subject { described_class.(config, select) }

    context 'with part select set' do
      it 'returns some files' do
        VCR.use_cassette 'select_files_sync/with_part_select_set', allow_playback_repeats: true do
          expect(subject[:public_token]).not_to be_empty
          expect(%i(plugins amp_styles).all? { |key| !subject[key].compact.empty? })
          expect(%i(editor_files theme_files standalone_styles fonts icons).all? { |key| subject[key].nil? }).to eq true
        end
      end
    end

    context 'with invalid select set' do
      let(:select) { 'plugins,invalid_select' }

      it 'return plugins' do
        VCR.use_cassette 'select_files_sync/with_invalid_select_set', allow_playback_repeats: true do
          expect(subject[:public_token]).not_to be_empty
          expect(%i(plugins).all? { |key| !subject[key].compact.empty? })
          expect(%i(amp_styles editor_files theme_files standalone_styles icons fonts).all? { |key| subject[key].nil? }).to eq true
        end
      end
    end

    context 'without select set' do
      let(:select) { 'invalid_select' }

      it 'return public token' do
        VCR.use_cassette 'select_files_sync/without_select_set', allow_playback_repeats: true do
          expect(subject[:public_token]).not_to be_empty
          expect(%i(plugins amp_styles editor_files theme_files standalone_styles icons fonts).all? { |key| subject[key].nil? }).to eq true
        end
      end
    end
  end

  describe 'public_token' do
    subject { described_class.new(config, select).public_token }

    context 'with part select set' do
      it 'return public token' do
        VCR.use_cassette 'select_files_sync/with_part_select_set', allow_playback_repeats: true do
          is_expected.to be_kind_of String
          is_expected.not_to be_empty
        end
      end
    end

    context 'without select set' do
      let(:select) { 'invalid_select' }

      it 'return public token' do
        VCR.use_cassette 'select_files_sync/without_select_set', allow_playback_repeats: true do
          is_expected.to be_kind_of String
          is_expected.not_to be_empty
        end
      end
    end
  end

  describe 'plugins' do
    subject { described_class.new(config, select).plugins }

    context 'with part select set' do
      it 'return plugins' do
        VCR.use_cassette 'select_files_sync/with_part_select_set', allow_playback_repeats: true do
          is_expected.to be_kind_of Array
          is_expected.not_to be_empty
        end
      end
    end

    context 'with invalid select set' do
      let(:select) { 'invalid_option' }

      it 'return nothing' do
        VCR.use_cassette 'select_files_sync/with_invalid_select_set', allow_playback_repeats: true do
          is_expected.to be_nil
        end
      end
    end
  end

  describe 'editor_files' do
    subject { described_class.new(config, select).editor_files }

    context 'with valid options' do
      it 'return nothing' do
        VCR.use_cassette 'select_files_sync/with_part_select_set', allow_playback_repeats: true do
          is_expected.to be_nil
        end
      end
    end

    context 'with invalid options' do
      let(:select) { 'plugins,invalid_option' }

      it 'return nothing' do
        VCR.use_cassette 'select_files_sync/with_invalid_select_set', allow_playback_repeats: true do
          is_expected.to be_nil
        end
      end
    end
  end

  describe 'theme_files' do
    subject { described_class.new(config, select).theme_files }

    context 'with valid options' do
      it 'return nothing' do
        VCR.use_cassette 'select_files_sync/with_part_select_set', allow_playback_repeats: true do
          is_expected.to be_nil
        end
      end
    end

    context 'with invalid options' do
      let(:select) { 'plugins,invalid_option' }

      it 'return nothing' do
        VCR.use_cassette 'select_files_sync/with_invalid_select_set', allow_playback_repeats: true do
          is_expected.to be_nil
        end
      end
    end
  end

  describe 'standalone_styles' do
    subject { described_class.new(config, select).standalone_styles }

    context 'with valid options' do
      it 'return nothing' do
        VCR.use_cassette 'select_files_sync/with_part_select_set', allow_playback_repeats: true do
          is_expected.to be_nil
        end
      end
    end

    context 'with invalid options' do
      let(:select) { 'plugins,invalid_option' }

      it 'return nothing' do
        VCR.use_cassette 'select_files_sync/with_invalid_select_set', allow_playback_repeats: true do
          is_expected.to be_nil
        end
      end
    end
  end

  describe 'amp_styles' do
    subject { described_class.new(config, select).amp_styles }

    context 'with valid options' do
      it 'return amp styles' do
        VCR.use_cassette 'select_files_sync/with_part_select_set', allow_playback_repeats: true do
          expect(subject.dig('common').all? { |common| common.is_a?(String) }).to eq true
          expect(subject.dig('themes').all? { |themes| themes.is_a?(String) }).to eq true
          expect(subject.dig('layouts').all? { |layouts| layouts.is_a?(String) }).to eq true
        end
      end
    end

    context 'with invalid options' do
      let(:select) { 'plugins,invalid_option' }

      it 'return amp styles' do
        VCR.use_cassette 'select_files_sync/with_invalid_select_set', allow_playback_repeats: true do
          is_expected.to be_nil
        end
      end
    end
  end

  describe 'fonts' do
    subject { described_class.new(config, select).fonts }

    context 'with valid options' do
      it 'return nothing' do
        VCR.use_cassette 'select_files_sync/with_part_select_set', allow_playback_repeats: true do
          is_expected.to be_nil
        end
      end
    end

    context 'with invalid options' do
      let(:select) { 'plugins,invalid_option' }

      it 'return nothing' do
        VCR.use_cassette 'select_files_sync/with_invalid_select_set', allow_playback_repeats: true do
          is_expected.to be_nil
        end
      end
    end
  end

  describe 'icons' do
    subject { described_class.new(config, select).icons }

    context 'with valid options' do
      it 'return nothing' do
        VCR.use_cassette 'select_files_sync/with_part_select_set', allow_playback_repeats: true do
          is_expected.to be_nil
        end
      end
    end

    context 'with invalid options' do
      let(:select) { 'plugins,invalid_option' }

      it 'return nothing' do
        VCR.use_cassette 'select_files_sync/with_invalid_select_set', allow_playback_repeats: true do
          is_expected.to be_nil
        end
      end
    end
  end
end
