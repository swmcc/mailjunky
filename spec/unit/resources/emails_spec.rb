# frozen_string_literal: true

require "spec_helper"

RSpec.describe MailJunky::Resources::Emails do
  let(:connection) { instance_double(MailJunky::Connection) }
  let(:emails) { described_class.new(connection) }

  describe "#send" do
    it "posts to the send endpoint with required params" do
      expect(connection).to receive(:post).with(
        "/api/v1/emails/send",
        hash_including(from: "sender@example.com", to: "recipient@example.com", subject: "Hello")
      ).and_return({ "id" => "123", "status" => "sent" })

      result = emails.send(
        from: "sender@example.com",
        to: "recipient@example.com",
        subject: "Hello",
        html: "<p>Hi</p>"
      )

      expect(result["status"]).to eq("sent")
    end

    it "includes optional params when provided" do
      expect(connection).to receive(:post).with(
        "/api/v1/emails/send",
        hash_including(cc: "cc@example.com", bcc: "bcc@example.com")
      ).and_return({})

      emails.send(
        from: "sender@example.com",
        to: "recipient@example.com",
        subject: "Hello",
        html: "<p>Hi</p>",
        cc: "cc@example.com",
        bcc: "bcc@example.com"
      )
    end

    it "includes reply_to when provided" do
      expect(connection).to receive(:post).with(
        "/api/v1/emails/send",
        hash_including(reply_to: "support@example.com")
      ).and_return({})

      emails.send(
        from: "sender@example.com",
        to: "recipient@example.com",
        subject: "Hello",
        html: "<p>Hi</p>",
        reply_to: "support@example.com"
      )
    end

    it "includes tags when provided" do
      expect(connection).to receive(:post).with(
        "/api/v1/emails/send",
        hash_including(tags: [{ name: "campaign", value: "welcome" }])
      ).and_return({})

      emails.send(
        from: "sender@example.com",
        to: "recipient@example.com",
        subject: "Hello",
        html: "<p>Hi</p>",
        tags: [{ name: "campaign", value: "welcome" }]
      )
    end

    it "includes metadata when provided" do
      expect(connection).to receive(:post).with(
        "/api/v1/emails/send",
        hash_including(metadata: { user_id: "123", order_id: "456" })
      ).and_return({})

      emails.send(
        from: "sender@example.com",
        to: "recipient@example.com",
        subject: "Hello",
        html: "<p>Hi</p>",
        metadata: { user_id: "123", order_id: "456" }
      )
    end

    it "excludes nil values from payload" do
      expect(connection).to receive(:post).with(
        "/api/v1/emails/send",
        { from: "sender@example.com", to: "recipient@example.com", subject: "Hello" }
      ).and_return({})

      emails.send(
        from: "sender@example.com",
        to: "recipient@example.com",
        subject: "Hello",
        html: nil,
        text: nil
      )
    end
  end

  describe "#send_batch" do
    it "posts to the batch endpoint" do
      batch = [
        { from: "sender@example.com", to: "user1@example.com", subject: "Hi 1", html: "<p>1</p>" },
        { from: "sender@example.com", to: "user2@example.com", subject: "Hi 2", html: "<p>2</p>" }
      ]

      expect(connection).to receive(:post).with(
        "/api/v1/emails/batch",
        { emails: batch }
      ).and_return({ "results" => [] })

      emails.send_batch(batch)
    end
  end
end
