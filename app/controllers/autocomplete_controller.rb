class AutocompleteController < ApplicationController
  before_action :authenticate_account!

  respond_to :json

  def zipcode
    value = params[:term].gsub(/\D/, '')
    response = ViacepService.find_by(:cep, value)

    if response.success?
      address = response.parsed

      data = {
        street: address.dig('logradouro'),
        number: '',
        complement: address.dig('complemento'),
        neighborhood: address.dig('bairro'),
        city_name: address.dig('localidade'),
        state: address.dig('uf'),
        zipcode: address.dig('cep')
      }

      json_response(data || {})
    else
      json_response({})
    end
  end
end