require 'spec_helper'
require 'setka_integration/api/select_files_sync'
require 'vcr_setup'

RSpec.describe SetkaIntegration::Api::SelectFilesSync do
  describe '.()' do
    context 'with part select set' do
      let(:params) do
        {
          token: 'UYHtFJUvAs7BOkoZZiVmryaFZltecJGT',
          select: 'plugins,amp'
        }
      end

      it 'have Setka editor fields' do
        VCR.use_cassette 'select_files_sync/with_part_options', allow_playback_repeats: true do
          result = described_class.new(params).()

          expect(result).to be_success
          expect(result.body['public_token']).not_to be_empty

          expect(result.body['plugins'].find { |file| file['filetype'] == 'js' }['url']).not_to be_empty

          aggregate_failures 'amp files' do
            expect(result.body.dig('amp_styles', 'common').all? { |common| common['url'].is_a?(String) }).to eq true
            expect(result.body.dig('amp_styles', 'themes').all? { |themes| themes['url'].is_a?(String) }).to eq true
            expect(result.body.dig('amp_styles', 'layouts').all? { |layouts| layouts['url'].is_a?(String) }).to eq true
          end
        end
      end
    end

    context 'with invalid select set' do
      let(:params) do
        {
          token: 'UYHtFJUvAs7BOkoZZiVmryaFZltecJGT',
          select: 'plugins,invalid_select'
        }
      end

      it 'have only plugins fields' do
        VCR.use_cassette 'select_files_sync/with_invalid_select_set', allow_playback_repeats: true do
          result = described_class.new(params).()

          expect(result.body.keys).to eq(%w(public_token plugins))
          expect(result.body['plugins']).not_to be_empty
        end
      end
    end

    context 'without select set' do
      let(:params) do
        {
          token: 'UYHtFJUvAs7BOkoZZiVmryaFZltecJGT',
          select: 'invalid_select'
        }
      end

      it 'have only plugins fields' do
        VCR.use_cassette 'select_files_sync/without_select_set', allow_playback_repeats: true do
          result = described_class.new(params).()

          expect(result).to be_success
          expect(result.body['public_token']).not_to be_empty

          expect(result.body['plugins']).to be_nil
          expect(result.body['editor_files']).to be_nil
          expect(result.body['theme_files']).to be_nil
          expect(result.body['standalone_styles']).to be_nil
          expect(result.body['amp_styles']).to be_nil
          expect(result.body['fonts']).to be_nil
          expect(result.body['icons']).to be_nil
        end
      end
    end
  end
end
