class Contact < ApplicationRecord
  belongs_to :account

  validates :name, :cpf, :phone, :street, :number, :neighborhood, :city_name, :state, :zipcode, presence: true
  validates :cpf, uniqueness: { scope: :account_id }
  validates_cpf_format_of :cpf
  validates :phone, phone: true

  before_validation :sanitize_data
  before_validation :set_lat_long

  def full_address
    "#{street}, #{number} - #{city_name} - #{state}, #{zipcode}"
  end

  def cpf_formatted
    CPF.new(cpf).formatted
  end

  def phone_formatted
    Phonelib.parse(phone)&.local_number
  end

  def self.search(account:, query:)
    return unless query.present?

    terms = query.split(/,\s| - |\s-\s/) # preserva os espaços em branco e remove os separadores(virgula e hífen)

    search_condition = terms.map do |term| # loop para montar a query, representando o termo de busca
      fields = %w[name cpf] # campos que serão pesquisados
        .map { |field| "#{field} ILIKE '%#{term}%'" }.join(" OR ")

      "(#{fields})"
    end.join(" AND ")

    result = where(search_condition)
    account ? result.where(account:) : result
  end

  private

  def sanitize_data
    self.cpf = CPF.new(cpf).stripped if cpf.present?
    self.phone = Phonelib.parse(phone)&.sanitized if phone.present?
  end

  def set_lat_long
    return unless street.present? && city_name.present? && state.present?

    response = GeocodingService.find_by(:address, [number, street, city_name, state].compact_blank)

    return unless response.success?

    data = response.parsed

    return if data['results'].empty?

    self.latitude = data['results'].first.dig('geometry', 'location', 'lat')
    self.longitude =  data['results'].first.dig('geometry', 'location', 'lng')
  end
end
