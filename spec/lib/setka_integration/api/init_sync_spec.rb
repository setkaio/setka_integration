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

          expect(result).to be_success
          expect(result.body['public_token']).not_to be_empty
          expect(result.body['plugins'].all? { |plugin| plugin['url'].is_a?(String) }).to eq true

          aggregate_failures 'editor files' do
            expect(result.body['editor_files'].find { |file| file['filetype'] == 'css' }['url']).to be_kind_of(String)
            expect(result.body['editor_files'].find { |file| file['filetype'] == 'js' }['url']).to be_kind_of(String)
          end

          aggregate_failures 'theme files' do
            expect(result.body['theme_files'].find { |file| file['filetype'] == 'css' }['url']).to be_kind_of(String)
            expect(result.body['theme_files'].find { |file| file['filetype'] == 'json' }['url']).to be_kind_of(String)
          end

          aggregate_failures 'standalone files' do
            expect(result.body.dig('standalone_styles', 'common').all? { |common| common['url'].is_a?(String) }).to eq true
            expect(result.body.dig('standalone_styles', 'themes').all? { |themes| themes['url'].is_a?(String) }).to eq true
            expect(result.body.dig('standalone_styles', 'layouts').all? { |layouts| layouts['url'].is_a?(String) }).to eq true
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
          expect(described_class.new(params).()).not_to be_success
        end
      end
    end

    context 'without token' do
      it 'deny access' do
        VCR.use_cassette 'init_sync/without_token' do
          expect(described_class.new.()).not_to be_success
        end
      end
    end
  end
end
