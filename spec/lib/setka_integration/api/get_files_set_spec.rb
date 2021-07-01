require 'spec_helper'
require 'setka_integration/api/get_files_set'
require 'vcr_setup'

RSpec.describe SetkaIntegration::Api::GetFilesSet do
  describe '.()' do
    context 'with part select set' do
      let(:params) do
        {
          token: 'UYHtFJUvAs7BOkoZZiVmryaFZltecJGT',
          select: 'plugins,amp'
        }
      end

      it 'have Setka editor fields' do
        VCR.use_cassette 'get_files_set/with_part_options', allow_playback_repeats: true do
          result = described_class.new(params).()
          body = JSON.parse(result.body)

          expect(result.code).to eq '200'
          expect(body['public_token']).not_to be_empty

          expect(body['plugins'].find { |file| file['filetype'] == 'js' }['url']).not_to be_empty

          aggregate_failures 'amp files' do
            expect(body.dig('amp_styles', 'common', 0, 'url')).not_to be_empty
            expect(body.dig('amp_styles', 'themes', 0, 'url')).not_to be_empty
            expect(body.dig('amp_styles', 'layouts', 0, 'url')).not_to be_empty
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
        VCR.use_cassette 'get_files_set/with_invalid_select_set', allow_playback_repeats: true do
          result = described_class.new(params).()
          body = JSON.parse(result.body)
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
        VCR.use_cassette 'get_files_set/without_select_set', allow_playback_repeats: true do
          result = described_class.new(params).()
          body = JSON.parse(result.body)

          expect(result.code).to eq '200'
          expect(body['public_token']).not_to be_empty

          expect(body['plugins']).to be_nil
          expect(body['editor_files']).to be_nil
          expect(body['theme_files']).to be_nil
          expect(body['standalone_styles']).to be_nil
          expect(body['amp_styles']).to be_nil
          expect(body['fonts']).to be_nil
          expect(body['icons']).to be_nil
        end
      end
    end
  end
end
