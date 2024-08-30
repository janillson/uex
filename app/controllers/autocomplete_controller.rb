class AutocompleteController < ApplicationController
  before_action :authenticate_account!

  respond_to :json

  def zipcode
    value = params[:term].gsub(/\D/, '')
    response = ViacepService.find_by(:cep, value)

    return json_response([]) unless response.success?

    address = response.parsed

    data = [{
      street: address.dig('logradouro'),
      number: '',
      complement: address.dig('complemento'),
      neighborhood: address.dig('bairro'),
      city_name: address.dig('localidade'),
      state: address.dig('uf'),
      zipcode: address.dig('cep')
    }]

    json_response(data)
  end

  def addresses
    query = params[:term].present? && params[:term] != 'null' ? params[:term] : nil

    puts "VVVVVVVVVVVVVVVVV"
    response = GeocodingService.find_by(:address, [query])

    return json_response([]) unless response.success?

    results = response.parsed['results']

    data = results.map do |address|
      details = address['address_components']

      {
        street: details.select { |detail| detail['types'].include?('route') }&.first&.dig('long_name') || '',
        number: details.select { |detail| detail['types'].include?('street_number') }&.first&.dig('long_name') || '',
        complement: '',
        neighborhood: details.select { |detail| detail['types'].include?('sublocality') }&.first&.dig('long_name') || '',
        city_name: details.select { |detail| detail['types'].include?('administrative_area_level_2') }&.first&.dig('long_name') || '',
        state: details.select { |detail| detail['types'].include?('administrative_area_level_1') }&.first&.dig('short_name'),
        zipcode: details.select { |detail| detail['types'].include?('postal_code') }&.first&.dig('long_name') || ''
      }
    end

    json_response(data)
  end

  def pins
    query = params[:term].present? && params[:term] != 'null' ? params[:term] : nil

    contacts = query ? Contact.search(account: current_account, query:) : current_account.contacts

    pins = contacts.pluck(:latitude, :longitude).map { |lat, lng| { lat: lat.to_f, lng: lng.to_f } }

    json_response(pins)
  end

  def contacts
    query = params[:term].present? && params[:term] != 'null' ? params[:term] : nil

    contacts = query ? Contact.search(account: current_account, query:) : current_account.contacts

    data = contacts.map do |contact|
      {
        name: contact.name,
        cpf: contact.cpf,
        phone: contact.phone,
        street: contact.street,
        number: contact.number,
        complement: contact.complement,
        neighborhood: contact.neighborhood,
        city_name: contact.city_name,
        state: contact.state,
        zipcode: contact.zipcode,
        latitude: contact.latitude,
        longitude: contact.longitude
      }
    end

    json_response(data)
  end
end