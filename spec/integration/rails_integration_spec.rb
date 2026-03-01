# frozen_string_literal: true

# Don't use spec_helper - we need to control load order precisely
require "bundler/setup"
require "rails"
require "action_mailer/railtie"
require "mailjunky"
require "mailjunky/rails"  # Explicitly load Rails integration after Rails is defined

# Define a proper app class for Rails
class TestMailjunkyApp < Rails::Application
  config.eager_load = false
  config.action_mailer.delivery_method = :mailjunky
  config.action_mailer.mailjunky_settings = { api_key: "test_key" }
end

RSpec.describe "Rails integration", type: :integration do
  # This test verifies that the railtie registers the delivery method
  # BEFORE Rails applies action_mailer settings from environment config.
  # Without the fix, this would raise:
  #   undefined method `mailjunky_settings=' for class ActionMailer::Base

  before(:all) do
    TestMailjunkyApp.initialize!
  end

  it "registers delivery method before config is applied" do
    expect(ActionMailer::Base.delivery_methods[:mailjunky]).to eq(MailJunky::Rails::DeliveryMethod)
  end

  it "accepts mailjunky_settings from environment config" do
    expect(ActionMailer::Base.mailjunky_settings).to eq({ api_key: "test_key" })
  end
end
