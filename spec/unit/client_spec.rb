# frozen_string_literal: true

require "spec_helper"

RSpec.describe MailJunky::Client do
  describe "#initialize" do
    it "creates client with api_key" do
      client = described_class.new(api_key: "mj_test_123")
      expect(client.emails).to be_a(MailJunky::Resources::Emails)
    end

    it "uses global configuration when no api_key given" do
      MailJunky.configure do |config|
        config.api_key = "mj_global_key"
      end

      client = described_class.new
      expect(client.emails).to be_a(MailJunky::Resources::Emails)
    end

    it "raises when no api_key available" do
      expect { described_class.new }.to raise_error(
        MailJunky::ConfigurationError, "API key is required"
      )
    end
  end
end
