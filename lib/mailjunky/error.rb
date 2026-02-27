# frozen_string_literal: true

module MailJunky
  class Error < StandardError; end

  class ConfigurationError < Error; end

  class APIError < Error
    attr_reader :status, :code, :body

    def initialize(message, status: nil, code: nil, body: nil)
      @status = status
      @code = code
      @body = body
      super(message)
    end
  end

  class AuthenticationError < APIError; end
  class RateLimitError < APIError; end
  class ValidationError < APIError; end
  class NotFoundError < APIError; end
  class ServerError < APIError; end
end
