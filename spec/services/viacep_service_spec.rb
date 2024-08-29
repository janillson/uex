require 'rails_helper'

RSpec.describe ViacepService do
  describe '.find_by' do
    context 'cep' do
      it 'returns the address' do
        VCR.use_cassette('viacep/cep/success') do
          response = described_class.find_by(:cep, '01001000')

          expect(response).to be_success
          expect(response.code).to eq(200)
          expect(response.parsed).to include(
            'cep' => '01001-000',
            'logradouro' => 'Praça da Sé',
            'complemento' => 'lado ímpar',
            'bairro' => 'Sé',
            'localidade' => 'São Paulo',
            'uf' => 'SP',
            'unidade' => '',
            'ibge' => '3550308',
            'gia' => '1004'
          )
        end
      end

      it 'returns not found' do
        VCR.use_cassette('viacep/cep/not_found') do
          response = described_class.find_by(:cep, '00000000')

          expect(response).to be_success
          expect(response.code).to eq(200)
          expect(response.parsed).to eq('erro' => 'true')
        end
      end
    end

    context 'address' do
      it 'returns the addresses' do
        VCR.use_cassette('viacep/address/success') do
          response = described_class.find_by(:address, ['SP', 'Sao Paulo', 'Praça da Se'])

          expect(response).to be_success
          expect(response.code).to eq(200)
          expect(response.parsed.first).to include(
            'cep' => '01001-000',
            'logradouro' => 'Praça da Sé',
            'complemento' => 'lado ímpar',
            'bairro' => 'Sé',
            'localidade' => 'São Paulo',
            'uf' => 'SP',
            'unidade' => '',
            'ibge' => '3550308',
            'gia' => '1004'
          )
        end
      end

      it 'returns not found' do
        VCR.use_cassette('viacep/address/not_found') do
          response = described_class.find_by(:address, ['SP', 'Sao Paulo', 'Rua inexistente'])

          expect(response).to be_success
          expect(response.code).to eq(200)
          expect(response.parsed).to eq([])
        end
      end
    end
  end
end