require 'spec_helper'
require 'setka_integration/select'

RSpec.describe SetkaIntegration::Select do
  subject { described_class.files(opts) }

  let(:license_key) { 'UYHtFJUvAs7BOkoZZiVmryaFZltecJGT' }
  let(:opts) { 'plugins,amp' }
  let(:params) { { token: license_key, select: opts } }

  before do
    SetkaIntegration::Config.configure(
      license_key: license_key
    )
  end

  describe '#files' do
    context 'with valid token' do
      it 'returns Setka editor files' do
        VCR.use_cassette 'select_files_sync/with_part_select_set', allow_playback_repeats: true do
          expect(%i(public_token plugins).all? { |key| subject[key].present? }).to eq true
          expect(subject[:amp_styles][:common]).to be_kind_of String
          expect(%i(themes layouts).all? { |key| subject[:amp_styles][key].is_a?(Array) }).to eq true
          expect(%i(editor_files theme_files standalone_styles fonts icons).all? { |key| subject[key].nil? }).to eq true
        end
      end
    end

    context 'with invalid select set' do
      let(:opts) { 'plugins,invalid_select' }

      it 'return plugins' do
        VCR.use_cassette 'select_files_sync/with_invalid_select_set', allow_playback_repeats: true do
          expect(%i(public_token plugins).all? { |key| subject[key].is_a?(String) }).to eq true
          expect(%i(public_token plugins).all? { |key| subject[key].present? }).to eq true
          expect(%i(amp_styles editor_files theme_files standalone_styles icons fonts).all? { |key| subject[key].nil? }).to eq true
        end
      end
    end
  end
end
