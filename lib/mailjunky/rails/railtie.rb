# frozen_string_literal: true

require "rails/railtie"

module MailJunky
  module Rails
    class Railtie < ::Rails::Railtie
      # Register delivery method before action_mailer.set_configs applies settings.
      # This ensures config.action_mailer.mailjunky_settings works in environment files.
      initializer "mailjunky.add_delivery_method", before: "action_mailer.set_configs" do
        ActionMailer::Base.add_delivery_method(:mailjunky, MailJunky::Rails::DeliveryMethod)
      end
    end
  end
end
