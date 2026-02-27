# frozen_string_literal: true

Dummy::Application.configure do
  config.cache_classes = true
  config.eager_load = false
  config.action_mailer.delivery_method = :test
  config.action_mailer.perform_deliveries = true
end
