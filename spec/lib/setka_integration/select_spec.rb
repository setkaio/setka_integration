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
          expect(subject[:public_token]).not_to be_empty
          expect(%i(plugins amp_styles).all? { |key| !subject[key].compact.empty? })
          expect(%i(editor_files theme_files standalone_styles fonts icons).all? { |key| subject[key].nil? }).to eq true
        end
      end
    end

    context 'with invalid select set' do
      let(:opts) { 'plugins,invalid_select' }

      it 'return plugins' do
        VCR.use_cassette 'select_files_sync/with_invalid_select_set', allow_playback_repeats: true do
          expect(subject[:public_token]).not_to be_empty
          expect(%i(plugins).all? { |key| !subject[key].compact.empty? })
          expect(%i(amp_styles editor_files theme_files standalone_styles icons fonts).all? { |key| subject[key].nil? }).to eq true
        end
      end
    end
  end

  describe 'option methods' do
    let(:response) do
      double({
        code: '200',
        body: { key1: 'value1', key2: 'value2' }.to_json
      })
    end

    let(:v2_request) { SetkaIntegration::Api::V2Request.new(params) }

    before do
      allow(Net::HTTP).to receive(:get_response).and_return response
      allow(v2_request).to receive(:response).and_return response
      expect(SetkaIntegration::Api::V2Request).to receive(:new).with(params).and_return(v2_request)
    end

    describe '#all' do
      let(:opts) { 'plugins,editor,theme,standalone,amp,fonts,icons' }

      it { expect { described_class.all }.not_to raise_error }
    end

    describe '#public_token' do
      let(:opts) { '' }

      it { expect { described_class.public_token }.not_to raise_error }
    end

    describe '#plugins' do
      let(:opts) { 'plugins' }

      it { expect { described_class.plugins }.not_to raise_error }
    end

    describe '#editor_files' do
      let(:opts) { 'editor' }

      it { expect { described_class.editor_files }.not_to raise_error }
    end

    describe '#theme_files' do
      let(:opts) { 'theme' }

      it { expect { described_class.theme_files }.not_to raise_error }
    end

    describe '#standalone_styles' do
      let(:opts) { 'standalone' }

      it { expect { described_class.standalone_styles }.not_to raise_error }
    end

    describe '#amp_styles' do
      let(:opts) { 'amp' }

      it { expect { described_class.amp_styles }.not_to raise_error }
    end

    describe '#fonts' do
      let(:opts) { 'fonts' }

      it { expect { described_class.fonts }.not_to raise_error }
    end

    describe '#icons' do
      let(:opts) { 'icons' }

      it { expect { described_class.icons }.not_to raise_error }
    end
  end
end
