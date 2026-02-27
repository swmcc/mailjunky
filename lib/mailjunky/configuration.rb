# frozen_string_literal: true

module MailJunky
  class Configuration
    attr_accessor :api_key, :base_url, :timeout, :open_timeout

    DEFAULT_BASE_URL = "https://api.mailjunky.ai"
    DEFAULT_TIMEOUT = 30
    DEFAULT_OPEN_TIMEOUT = 10

    def initialize
      @base_url = DEFAULT_BASE_URL
      @timeout = DEFAULT_TIMEOUT
      @open_timeout = DEFAULT_OPEN_TIMEOUT
    end

    def validate!
      raise ConfigurationError, "API key is required" if api_key.nil? || api_key.empty?
    end
  end
end
