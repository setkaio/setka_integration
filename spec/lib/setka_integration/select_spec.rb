require 'spec_helper'
require 'setka_integration/select'

RSpec.describe SetkaIntegration::Select do
  subject { described_class.files }

  let(:license_key) { 'UYHtFJUvAs7BOkoZZiVmryaFZltecJGT' }
  let(:select) { 'plugins,amp' }

  before do
    SetkaIntegration::Config.configure(
      license_key: license_key,
      select: select
    )
  end

  describe '#files' do
    context 'with valid token' do
      it 'returns Setka editor files' do
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
  end
end
