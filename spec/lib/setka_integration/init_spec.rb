require 'spec_helper'
require 'setka_integration/init'

RSpec.describe SetkaIntegration::Init do
  before do
    SetkaIntegration::Config.configure(
      license_key: license_key
    )
  end

  describe '#files' do
    subject { described_class.files }

    context 'with valid token' do
      let(:license_key) { 'UYHtFJUvAs7BOkoZZiVmryaFZltecJGT' }

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

  describe 'atomic methods' do
    subject { described_class }

    context 'with valid token' do
      let(:license_key) { 'UYHtFJUvAs7BOkoZZiVmryaFZltecJGT' }

      it 'returns Setka editor files' do
        VCR.use_cassette 'init_sync/with_valid_token', allow_playback_repeats: true do
          expect(%i(common common_critical common_deferred).all? { |key| subject.public_send(:standalone_styles)[key].is_a?(String) }).to eq true
          expect(%i(themes layouts themes_critical themes_deferred).all? { |key| subject.public_send(:standalone_styles)[key].is_a?(Array) }).to eq true
          expect(%i(public_token plugins).all? { |key| subject.public_send(key).is_a?(String) }).to eq true
          expect(%i(css js).all? { |filetype| subject.public_send(:editor_files).public_send(filetype).is_a?(String) }).to eq true
          expect(%i(css json).all? { |filetype| subject.public_send(:theme_files).public_send(filetype).is_a?(String) }).to eq true
        end
      end
    end

    context 'with invalid token' do
      let(:license_key) { 'wrong token' }

      it 'return error' do
        VCR.use_cassette 'init_sync/with_invalid_token', allow_playback_repeats: true do
          expect { %i(plugins editor_files theme_files).all? { |key| subject.public_send(key) } }.to raise_error(SetkaIntegration::Error, 'Not authorized!')
        end
      end
    end
  end
end
