require 'rails_helper'

RSpec.describe GeocodingService do
  describe '.find_by' do
    before do
      VCR.configure do |c|
        c.filter_sensitive_data('GOOGLE_API_KEY') { ENV['GOOGLE_API_KEY'] }
      end
    end

    context 'address' do
      it 'returns the address' do
        VCR.use_cassette('geocoding/address/success') do
          response = described_class.find_by(:address, ['Rua da Consolacao', 'Sao Paulo'])

          expect(response).to be_success
          expect(response.code).to eq(200)
          expect(response.parsed['results'].first.dig('geometry', 'location')).to include(
            'lat' => -23.5528373,
            'lng' => -46.6590576
          )
        end
      end

      it 'returns not found' do
        VCR.use_cassette('geocoding/address/not_found') do
          response = described_class.find_by(:address, ['Rua inexistente', 'Cidade inexistente'])

          expect(response).to be_success
          expect(response.code).to eq(200)
          expect(response.parsed).to eq({'results' => [], 'status' => 'ZERO_RESULTS'})
        end
      end
    end

    context 'latlng' do
      it 'returns the address' do
        VCR.use_cassette('geocoding/latlng/success') do
          response = described_class.find_by(:latlng, [-23.5528373, -46.6590576])

          expect(response).to be_success
          expect(response.code).to eq(200)
          expect(response.parsed['results'].first.dig('formatted_address')).to eq('R. da Consolação, 1937 - Consolação, São Paulo - SP, 01301-100, Brazil')
        end
      end

      it 'returns not found' do
        VCR.use_cassette('geocoding/latlng/not_found') do
          response = described_class.find_by(:latlng, [0, 0])

          expect(response).to be_success
          expect(response.code).to eq(200)
          expect(response.parsed).to eq({'results' => [], 'status' => 'ZERO_RESULTS'})
        end
      end
    end
  end
end