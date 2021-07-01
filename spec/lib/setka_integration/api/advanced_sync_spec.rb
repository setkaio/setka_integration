require 'spec_helper'
require 'setka_integration/api/advanced_sync'
require 'vcr_setup'

RSpec.describe SetkaIntegration::Api::AdvancedSync do
  describe '.()' do
    context 'with part options' do
      let(:params) do
        {
          token: 'UYHtFJUvAs7BOkoZZiVmryaFZltecJGT',
          options: 'amp,icons'
        }
      end

      it 'have Setka editor fields' do
        VCR.use_cassette 'advanced_sync/with_part_options', allow_playback_repeats: true do
          result = described_class.new(params).()
          body = JSON.parse(result.body)

          expect(result.code).to eq '200'
          expect(body['public_token']).not_to be_empty
          expect(body.dig('plugins', 0, 'url')).not_to be_empty

          aggregate_failures 'editor files' do
            expect(body['editor_files'].find { |file| file['filetype'] == 'css' }['url']).not_to be_empty
            expect(body['editor_files'].find { |file| file['filetype'] == 'js' }['url']).not_to be_empty
          end

          aggregate_failures 'theme files' do
            expect(body['editor_files'].find { |file| file['filetype'] == 'css' }['url']).not_to be_empty
            expect(body['editor_files'].find { |file| file['filetype'] == 'js' }['url']).not_to be_empty
          end

          aggregate_failures 'standalone files' do
            expect(body.dig('standalone_styles', 'common', 0, 'url')).not_to be_empty
            expect(body.dig('standalone_styles', 'themes', 0, 'url')).not_to be_empty
            expect(body.dig('standalone_styles', 'layouts', 0, 'url')).not_to be_empty
          end

          aggregate_failures 'amp files' do
            expect(body.dig('amp_styles', 'common', 0, 'url')).not_to be_empty
            expect(body.dig('amp_styles', 'themes', 0, 'url')).not_to be_empty
            expect(body.dig('amp_styles', 'layouts', 0, 'url')).not_to be_empty
          end

          expect(body.dig('icons')).to be_empty
        end
      end

      it 'no have fonts fields' do
        VCR.use_cassette 'advanced_sync/with_part_options' do
          expect(JSON.parse(described_class.new(params).().body).dig('fonts', 0, 'url')).to be_nil
        end
      end
    end

    context 'with invalid options' do
      let(:params) do
        {
          token: 'UYHtFJUvAs7BOkoZZiVmryaFZltecJGT',
          options: 'amp,invalid_option'
        }
      end

      it 'have only amp fields' do
        VCR.use_cassette 'advanced_sync/with_invalid_options', allow_playback_repeats: true do
          result = described_class.new(params).()
          body = JSON.parse(result.body)

          expect(result.code).to eq '200'

          aggregate_failures 'amp files' do
            expect(body.dig('amp_styles', 'common', 0, 'url')).not_to be_empty
            expect(body.dig('amp_styles', 'themes', 0, 'url')).not_to be_empty
            expect(body.dig('amp_styles', 'layouts', 0, 'url')).not_to be_empty
          end

          expect(body.dig('icons')).to be_nil
          expect(body.dig('fonts')).to be_nil
        end
      end
    end

    context 'without options' do
      let(:params) do
        {
          token: 'UYHtFJUvAs7BOkoZZiVmryaFZltecJGT'
        }
      end

      it 'have only Setka editor config files' do
        VCR.use_cassette 'advanced_sync/without_options', allow_playback_repeats: true do
          result = described_class.new(params).()
          body = JSON.parse(result.body)

          expect(result.code).to eq '200'

          expect(body['public_token']).not_to be_empty
          expect(body.dig('plugins')).not_to be_empty
          expect(body.dig('editor_files')).not_to be_empty
          expect(body.dig('theme_files')).not_to be_empty
          expect(body.dig('standalone_styles')).not_to be_empty

          expect(body.dig('icons')).to be_nil
          expect(body.dig('fonts')).to be_nil
        end
      end
    end
  end
end
