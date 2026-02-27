# frozen_string_literal: true

require "rails/railtie"

module MailJunky
  module Rails
    class Railtie < ::Rails::Railtie
      initializer "mailjunky.add_delivery_method" do
        ActiveSupport.on_load(:action_mailer) do
          ActionMailer::Base.add_delivery_method(:mailjunky, MailJunky::Rails::DeliveryMethod)
        end
      end
    end
  end
end
