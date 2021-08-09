require 'spec_helper'
require 'setka_integration/options'

RSpec.describe SetkaIntegration::Options do
  subject { described_class.files(opts) }

  let(:license_key) { 'UYHtFJUvAs7BOkoZZiVmryaFZltecJGT' }
  let(:opts) { 'amp,icons' }

  before do
    SetkaIntegration::Config.configure(
      license_key: license_key
    )
  end

  describe '#files' do
    context 'with valid token' do
      it 'returns Setka editor files' do
        VCR.use_cassette 'advanced_sync/with_part_options', allow_playback_repeats: true do
          expect(%i(public_token plugins).all? { |key| subject[key].is_a?(String) }).to eq true
          expect(%i(common common_critical common_deferred).all? { |key| subject[:standalone_styles][key].is_a?(String) }).to eq true
          expect(%i(themes layouts themes_critical themes_deferred).all? { |key| subject[:standalone_styles][key].is_a?(Array) }).to eq true
          expect(subject[:amp_styles][:common]).to be_kind_of String
          expect(%i(themes layouts).all? { |key| subject[:amp_styles][key].is_a?(Array) }).to eq true
          expect(%i(css js).all? { |filetype| subject[:editor_files][filetype].is_a?(String) }).to eq true
          expect(%i(css json).all? { |filetype| subject[:theme_files][filetype].is_a?(String) }).to eq true
          expect(subject[:icons]).to be_empty
          expect(subject[:fonts]).to be_nil
        end
      end
    end

    context 'with invalid options' do
      let(:opts) { 'amp,invalid_option' }

      it 'return Setka editor files' do
        VCR.use_cassette 'advanced_sync/with_invalid_options', allow_playback_repeats: true do
          expect(%i(public_token plugins).all? { |key| subject[key].is_a?(String) }).to eq true
          expect(%i(common common_critical common_deferred).all? { |key| subject.public_send(:standalone_styles)[key].is_a?(String) }).to eq true
          expect(%i(themes layouts themes_critical themes_deferred).all? { |key| subject.public_send(:standalone_styles)[key].is_a?(Array) }).to eq true
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

  describe '#public_token' do
    subject { described_class }

    context 'with valid token' do
      it 'returns Setka editor public token' do
        VCR.use_cassette 'advanced_sync/with_public_token_options', allow_playback_repeats: true do
          expect(subject.public_token).to be_present
          expect(subject.public_token).to be_kind_of(String)
        end
      end
    end
  end

  describe '#amp_styles' do
    subject { described_class }

    context 'with valid token' do
      it 'returns Setka editor amp styles' do
        VCR.use_cassette 'advanced_sync/with_amp_options', allow_playback_repeats: true do
          expect(%i(common).all? { |key| subject.amp_styles[key].is_a?(String) }).to eq true
          expect(%i(themes layouts).all? { |key| subject.amp_styles[key].is_a?(Array) }).to eq true
        end
      end
    end
  end

  describe '#icons' do
    subject { described_class }

    context 'with valid token' do
      it 'returns Setka editor icons' do
        VCR.use_cassette 'advanced_sync/with_icons_options', allow_playback_repeats: true do
          expect(subject.icons).to be_empty
          expect(subject.icons).to be_kind_of Array
        end
      end
    end
  end
end
