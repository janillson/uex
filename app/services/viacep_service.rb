require 'http'

class ViacepService
  BASE_URL = 'https://viacep.com.br/ws'.freeze

  class Response
    attr_accessor :code, :parsed, :headers, :body

    def initialize(code:, parsed:, headers: nil, body: nil)
      @code = code
      @headers = headers
      @body = body
      @parsed = parsed
    end

    def success?
      code.to_i >= 200 && code.to_i < 300
    end
  end

  def self.find_by(type, value)
    params = case type&.to_sym
             when :cep then value
             when :address then value.join('/')
             end

    return unless params.present?

    response = HTTP.get("#{BASE_URL}/#{params}/json/")
    result(response)
  end

  private

  def self.result(response)
    Response.new(
      code: response.code,
      parsed: parsed_response(response),
      headers: response.headers.to_h,
      body: response.body.to_s
    )
  end

  def self.parsed_response(response)
    response.parse
  rescue HTTP::Error, JSON::ParserError
    response.body
  end
end