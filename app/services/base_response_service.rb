class BaseResponseService
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