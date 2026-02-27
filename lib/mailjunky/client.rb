# frozen_string_literal: true

module MailJunky
  class Client
    attr_reader :emails

    def initialize(api_key: nil, base_url: nil, timeout: nil, open_timeout: nil)
      config = Configuration.new
      config.api_key = api_key || MailJunky.configuration.api_key
      config.base_url = base_url if base_url
      config.timeout = timeout if timeout
      config.open_timeout = open_timeout if open_timeout

      connection = Connection.new(config)

      @emails = Resources::Emails.new(connection)
    end
  end
end
