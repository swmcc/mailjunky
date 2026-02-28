# frozen_string_literal: true

require_relative "mailjunky/version"
require_relative "mailjunky/error"
require_relative "mailjunky/configuration"
require_relative "mailjunky/connection"
require_relative "mailjunky/resources/base"
require_relative "mailjunky/resources/emails"
require_relative "mailjunky/client"

module MailJunky
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end

require_relative "mailjunky/rails" if defined?(Rails)
