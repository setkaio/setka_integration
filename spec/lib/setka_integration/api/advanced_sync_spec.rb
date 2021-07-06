require 'spec_helper'
require 'setka_integration/api/advanced_sync'

RSpec.describe SetkaIntegration::Api::AdvancedSync do
  let(:valid_token) { 'UYHtFJUvAs7BOkoZZiVmryaFZltecJGT' }
  let(:config) { { license_key: valid_token, host: 'https://editor.setka.io' } }

  before do
    SetkaIntegration.configure(config)
  end

  describe '.()' do
    context 'with part options' do
      let(:params) do
        {
          token: valid_token,
          options: 'amp,icons'
        }
      end

      it 'have Setka editor fields' do
        VCR.use_cassette 'advanced_sync/with_part_options', allow_playback_repeats: true do
          result = described_class.new(params).()

          expect(result).to be_success
          expect(result.body['public_token']).not_to be_empty
          expect(result.body.dig('plugins').all? { |plugins| plugins['url'].is_a?(String) }).to eq true

          aggregate_failures 'editor files' do
            expect(result.body['editor_files'].find { |file| file['filetype'] == 'css' }['url']).not_to be_empty
            expect(result.body['editor_files'].find { |file| file['filetype'] == 'js' }['url']).not_to be_empty
          end

          aggregate_failures 'theme files' do
            expect(result.body['editor_files'].find { |file| file['filetype'] == 'css' }['url']).not_to be_empty
            expect(result.body['editor_files'].find { |file| file['filetype'] == 'js' }['url']).not_to be_empty
          end

          aggregate_failures 'standalone files' do
            expect(result.body.dig('standalone_styles', 'common').all? { |common| common['url'].is_a?(String) }).to eq true
            expect(result.body.dig('standalone_styles', 'themes').all? { |themes| themes['url'].is_a?(String) }).to eq true
            expect(result.body.dig('standalone_styles', 'layouts').all? { |layouts| layouts['url'].is_a?(String) }).to eq true
          end

          aggregate_failures 'amp files' do
            expect(result.body.dig('amp_styles', 'common').all? { |common| common['url'].is_a?(String) }).to eq true
            expect(result.body.dig('amp_styles', 'themes').all? { |themes| themes['url'].is_a?(String) }).to eq true
            expect(result.body.dig('amp_styles', 'layouts').all? { |layouts| layouts['url'].is_a?(String) }).to eq true
          end

          expect(result.body.dig('icons')).to be_empty
        end
      end

      it 'no have fonts fields' do
        VCR.use_cassette 'advanced_sync/with_part_options' do
          expect(described_class.new(params).().body.dig('fonts', 0, 'url')).to be_nil
        end
      end
    end

    context 'with invalid options' do
      let(:params) do
        {
          token: valid_token,
          options: 'amp,invalid_option'
        }
      end

      it 'have only amp fields' do
        VCR.use_cassette 'advanced_sync/with_invalid_options', allow_playback_repeats: true do
          result = described_class.new(params).()

          expect(result).to be_success

          aggregate_failures 'amp files' do
            expect(result.body.dig('amp_styles', 'common').all? { |common| common['url'].is_a?(String) }).to eq true
            expect(result.body.dig('amp_styles', 'themes').all? { |themes| themes['url'].is_a?(String) }).to eq true
            expect(result.body.dig('amp_styles', 'layouts').all? { |layouts| layouts['url'].is_a?(String) }).to eq true
          end

          expect(result.body.dig('icons')).to be_nil
          expect(result.body.dig('fonts')).to be_nil
        end
      end
    end

    context 'without options' do
      let(:params) do
        {
          token: valid_token
        }
      end

      it 'have only Setka editor config files' do
        VCR.use_cassette 'advanced_sync/without_options', allow_playback_repeats: true do
          result = described_class.new(params).()

          expect(result).to be_success

          expect(result.body['public_token']).not_to be_empty
          expect(result.body.dig('plugins')).not_to be_empty
          expect(result.body.dig('editor_files')).not_to be_empty
          expect(result.body.dig('theme_files')).not_to be_empty
          expect(result.body.dig('standalone_styles')).not_to be_empty

          expect(result.body.dig('icons')).to be_nil
          expect(result.body.dig('fonts')).to be_nil
        end
      end
    end
  end
end
