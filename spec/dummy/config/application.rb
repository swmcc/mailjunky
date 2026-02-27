# frozen_string_literal: true

require "action_mailer/railtie"

module Dummy
  class Application < Rails::Application
    config.eager_load = false
    config.active_support.deprecation = :stderr
  end
end
