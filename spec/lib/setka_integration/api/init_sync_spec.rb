require 'spec_helper'
require 'setka_integration/api/init_sync'
require 'vcr_setup'

RSpec.describe SetkaIntegration::Api::InitSync do
  describe '.()' do
    context 'with valid token' do
      let(:params) do
        { token: 'UYHtFJUvAs7BOkoZZiVmryaFZltecJGT' }
      end

      it 'have Setka editor fields' do
        VCR.use_cassette 'init_sync/with_valid_token', allow_playback_repeats: true do
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
            expect(body['theme_files'].find { |file| file['filetype'] == 'css' }['url']).not_to be_empty
            expect(body['theme_files'].find { |file| file['filetype'] == 'json' }['url']).not_to be_empty
          end

          aggregate_failures 'standalone files' do
            expect(body.dig('standalone_styles', 'common', 0, 'url')).not_to be_empty
            expect(body.dig('standalone_styles', 'themes', 0, 'url')).not_to be_empty
            expect(body.dig('standalone_styles', 'layouts', 0, 'url')).not_to be_empty
          end
        end
      end
    end

    context 'with invalid token' do
      let(:params) do
        { token: 'wrong token' }
      end

      it 'deny access' do
        VCR.use_cassette 'init_sync/with_invalid_token' do
          expect(described_class.new(params).().code).to eq '401'
        end
      end
    end

    context 'without token' do
      it 'deny access' do
        VCR.use_cassette 'init_sync/without_token' do
          expect(described_class.new.().code).to eq '401'
        end
      end
    end
  end
end
