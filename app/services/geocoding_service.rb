class GeocodingService < BaseResponseService
  BASE_URL = 'https://maps.googleapis.com/maps/api/geocode/json'.freeze

  def self.find_by(type, value)
    params = case type&.to_sym
             when :address then value.join('+').split.join('+')
             when :latlng then value.join(',')
             end

    return unless params.present?

    response = HTTP.get("#{BASE_URL}?#{type}=#{params}&key=#{ENV['GOOGLE_API_KEY']}")
    result(response)
  end
end