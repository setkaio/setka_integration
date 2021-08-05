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
          expect(subject[:public_token]).to be_present
          expect(%i(plugins editor_files theme_files standalone_styles amp_styles).all? { |key| subject[key].compact.present? }).to eq true
          expect(subject[:icons]).to be_empty
          expect(subject[:fonts]).to be_nil
        end
      end
    end

    context 'with invalid options' do
      let(:opts) { 'amp,invalid_option' }

      it 'return error' do
        VCR.use_cassette 'advanced_sync/with_invalid_options', allow_playback_repeats: true do
          expect(subject[:public_token]).to be_present
          expect(%i(plugins editor_files theme_files standalone_styles amp_styles).all? { |key| subject[key].compact.present? }).to eq true
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
          expect(subject.amp_styles).to be_present
          expect(subject.amp_styles).to be_kind_of Hash
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
