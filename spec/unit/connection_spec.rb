# frozen_string_literal: true

require "spec_helper"

RSpec.describe MailJunky::Connection do
  let(:config) do
    MailJunky::Configuration.new.tap do |c|
      c.api_key = "mj_test_123"
    end
  end

  subject(:connection) { described_class.new(config) }

  describe "error handling" do
    it "raises AuthenticationError on 401" do
      stub_request(:get, "https://api.mailjunky.ai/test")
        .to_return(status: 401, body: { message: "Invalid API key" }.to_json)

      expect { connection.get("/test") }.to raise_error(MailJunky::AuthenticationError)
    end

    it "raises NotFoundError on 404" do
      stub_request(:get, "https://api.mailjunky.ai/test")
        .to_return(status: 404, body: { message: "Not found" }.to_json)

      expect { connection.get("/test") }.to raise_error(MailJunky::NotFoundError)
    end

    it "raises ValidationError on 422" do
      stub_request(:post, "https://api.mailjunky.ai/test")
        .to_return(status: 422, body: { message: "Invalid email" }.to_json)

      expect { connection.post("/test", {}) }.to raise_error(MailJunky::ValidationError)
    end

    it "raises RateLimitError on 429" do
      stub_request(:get, "https://api.mailjunky.ai/test")
        .to_return(status: 429, body: { message: "Too many requests" }.to_json)

      expect { connection.get("/test") }.to raise_error(MailJunky::RateLimitError)
    end

    it "raises ServerError on 500" do
      stub_request(:get, "https://api.mailjunky.ai/test")
        .to_return(status: 500, body: { message: "Internal error" }.to_json)

      expect { connection.get("/test") }.to raise_error(MailJunky::ServerError)
    end
  end

  describe "successful requests" do
    it "returns parsed JSON body" do
      stub_request(:get, "https://api.mailjunky.ai/test")
        .to_return(status: 200, body: { id: "123", status: "ok" }.to_json)

      result = connection.get("/test")

      expect(result).to eq({ "id" => "123", "status" => "ok" })
    end
  end
end
