# frozen_string_literal: true

require "faraday"
require "json"

module MailJunky
  class Connection
    def initialize(config)
      @config = config
      @config.validate!
    end

    def get(path, params = {})
      request(:get, path, nil, params)
    end

    def post(path, body = {})
      request(:post, path, body)
    end

    def patch(path, body = {})
      request(:patch, path, body)
    end

    def delete(path)
      request(:delete, path)
    end

    private

    def request(method, path, body = nil, params = nil)
      response = connection.public_send(method, path) do |req|
        req.params = params if params&.any?
        req.body = JSON.generate(body) if body
      end

      handle_response(response)
    end

    def connection
      @connection ||= Faraday.new(url: @config.base_url) do |conn|
        conn.headers["Authorization"] = "Bearer #{@config.api_key}"
        conn.headers["Content-Type"] = "application/json"
        conn.headers["User-Agent"] = "mailjunky-ruby/#{VERSION}"
        conn.options.timeout = @config.timeout
        conn.options.open_timeout = @config.open_timeout
        conn.adapter Faraday.default_adapter
      end
    end

    def handle_response(response)
      body = parse_body(response.body)

      case response.status
      when 200..299
        body
      when 401
        raise AuthenticationError.new(
          body["message"] || "Authentication failed",
          status: response.status, code: body["code"], body: body
        )
      when 404
        raise NotFoundError.new(
          body["message"] || "Not found",
          status: response.status, code: body["code"], body: body
        )
      when 422
        raise ValidationError.new(
          body["message"] || "Validation failed",
          status: response.status, code: body["code"], body: body
        )
      when 429
        raise RateLimitError.new(
          body["message"] || "Rate limit exceeded",
          status: response.status, code: body["code"], body: body
        )
      when 500..599
        raise ServerError.new(
          body["message"] || "Server error",
          status: response.status, code: body["code"], body: body
        )
      else
        raise APIError.new(
          body["message"] || "Request failed",
          status: response.status, code: body["code"], body: body
        )
      end
    end

    def parse_body(body)
      return {} if body.nil? || body.empty?

      JSON.parse(body)
    rescue JSON::ParserError
      {}
    end
  end
end
