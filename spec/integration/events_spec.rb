# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Tracking events", type: :integration do
  let(:client) { MailJunky::Client.new(api_key: "test_api_key") }

  before do
    stub_request(:post, "https://api.mailjunky.ai/api/v1/events/track")
      .to_return(
        status: 200,
        body: { success: true, event_id: "evt_abc123" }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end

  describe "client.events.track" do
    it "tracks an event and returns the response" do
      response = client.events.track(
        event: "button_clicked",
        user: "user@example.com",
        properties: { button_id: "signup" }
      )

      expect(response["success"]).to be true
      expect(response["event_id"]).to eq("evt_abc123")
    end

    it "makes the correct request" do
      client.events.track(
        event: "purchase_completed",
        user: "buyer@example.com",
        properties: { amount: 100, currency: "USD" }
      )

      expect(WebMock).to have_requested(:post, "https://api.mailjunky.ai/api/v1/events/track")
        .with(
          body: {
            event: "purchase_completed",
            user: "buyer@example.com",
            properties: { amount: 100, currency: "USD" }
          },
          headers: { "Authorization" => "Bearer test_api_key" }
        )
    end
  end
end
