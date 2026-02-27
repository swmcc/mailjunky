# frozen_string_literal: true

require "spec_helper"

RSpec.describe MailJunky::Configuration do
  subject(:config) { described_class.new }

  describe "defaults" do
    it "sets default base_url" do
      expect(config.base_url).to eq("https://api.mailjunky.ai")
    end

    it "sets default timeout" do
      expect(config.timeout).to eq(30)
    end

    it "sets default open_timeout" do
      expect(config.open_timeout).to eq(10)
    end
  end

  describe "#validate!" do
    it "raises when api_key is nil" do
      expect { config.validate! }.to raise_error(
        MailJunky::ConfigurationError, "API key is required"
      )
    end

    it "raises when api_key is empty" do
      config.api_key = ""
      expect { config.validate! }.to raise_error(
        MailJunky::ConfigurationError, "API key is required"
      )
    end

    it "passes when api_key is set" do
      config.api_key = "mj_test_123"
      expect { config.validate! }.not_to raise_error
    end
  end
end
