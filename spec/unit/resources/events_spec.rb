# frozen_string_literal: true

require "spec_helper"

RSpec.describe MailJunky::Resources::Events do
  let(:connection) { instance_double(MailJunky::Connection) }
  let(:events) { described_class.new(connection) }

  describe "#track" do
    it "posts to the track endpoint with required params" do
      expect(connection).to receive(:post).with(
        "/api/v1/events/track",
        { event: "signup_completed" }
      )

      events.track(event: "signup_completed")
    end

    it "includes optional params when provided" do
      expect(connection).to receive(:post).with(
        "/api/v1/events/track",
        {
          event: "subscription_renewed",
          user: "user@example.com",
          properties: { plan: "pro", amount: 99 },
          session_id: "sess_123",
          timestamp: "2026-02-27T12:00:00Z"
        }
      )

      events.track(
        event: "subscription_renewed",
        user: "user@example.com",
        properties: { plan: "pro", amount: 99 },
        session_id: "sess_123",
        timestamp: "2026-02-27T12:00:00Z"
      )
    end

    it "excludes nil values from payload" do
      expect(connection).to receive(:post).with(
        "/api/v1/events/track",
        { event: "page_viewed", user: "user@example.com" }
      )

      events.track(event: "page_viewed", user: "user@example.com")
    end
  end
end
