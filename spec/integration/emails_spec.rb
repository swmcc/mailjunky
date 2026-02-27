# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Sending emails" do
  let(:client) { MailJunky::Client.new(api_key: "mj_test_123") }

  describe "client.emails.send" do
    before do
      stub_request(:post, "https://api.mailjunky.ai/api/v1/emails/send")
        .to_return(
          status: 200,
          body: { id: "msg_123", message_id: "abc", status: "sent" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "sends an email and returns the response" do
      response = client.emails.send(
        from: "hello@example.com",
        to: "user@example.com",
        subject: "Welcome!",
        html: "<h1>Welcome</h1>"
      )

      expect(response["status"]).to eq("sent")
      expect(response["id"]).to eq("msg_123")
    end

    it "makes the correct request" do
      client.emails.send(
        from: "hello@example.com",
        to: "user@example.com",
        subject: "Welcome!",
        html: "<h1>Welcome</h1>"
      )

      expect(WebMock).to have_requested(:post, "https://api.mailjunky.ai/api/v1/emails/send")
        .with(
          body: hash_including(
            "from" => "hello@example.com",
            "to" => "user@example.com",
            "subject" => "Welcome!"
          ),
          headers: {
            "Authorization" => "Bearer mj_test_123",
            "Content-Type" => "application/json"
          }
        )
    end
  end

  describe "error handling" do
    it "raises AuthenticationError with invalid key" do
      stub_request(:post, "https://api.mailjunky.ai/api/v1/emails/send")
        .to_return(status: 401, body: { message: "Invalid API key" }.to_json)

      expect do
        client.emails.send(from: "a@b.com", to: "c@d.com", subject: "Hi", html: "<p>Hi</p>")
      end.to raise_error(MailJunky::AuthenticationError, "Invalid API key")
    end
  end
end
