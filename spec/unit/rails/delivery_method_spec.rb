# frozen_string_literal: true

require "spec_helper"
require "mail"
require "mailjunky/rails/delivery_method"

RSpec.describe MailJunky::Rails::DeliveryMethod do
  let(:client) { instance_double(MailJunky::Client) }
  let(:emails) { instance_double(MailJunky::Resources::Emails) }
  let(:delivery_method) { described_class.new(settings) }
  let(:settings) { {} }

  before do
    allow(MailJunky::Client).to receive(:new).and_return(client)
    allow(client).to receive(:emails).and_return(emails)
    allow(emails).to receive(:send)
  end

  describe "#deliver!" do
    context "with a simple text email" do
      let(:mail) do
        Mail.new do
          from    "sender@example.com"
          to      "recipient@example.com"
          subject "Hello"
          body    "Plain text body"
        end
      end

      it "sends via mailjunky client" do
        expect(emails).to receive(:send).with(
          from: "sender@example.com",
          to: ["recipient@example.com"],
          subject: "Hello",
          text: "Plain text body"
        )

        delivery_method.deliver!(mail)
      end
    end

    context "with an HTML email" do
      let(:mail) do
        Mail.new do
          from    "sender@example.com"
          to      "recipient@example.com"
          subject "Hello"

          html_part do
            content_type "text/html; charset=UTF-8"
            body "<h1>Hello</h1>"
          end
        end
      end

      it "sends html content" do
        expect(emails).to receive(:send).with(
          from: "sender@example.com",
          to: ["recipient@example.com"],
          subject: "Hello",
          html: "<h1>Hello</h1>"
        )

        delivery_method.deliver!(mail)
      end
    end

    context "with a multipart email" do
      let(:mail) do
        Mail.new do
          from    "sender@example.com"
          to      "recipient@example.com"
          subject "Hello"

          text_part do
            body "Plain text"
          end

          html_part do
            content_type "text/html; charset=UTF-8"
            body "<h1>HTML</h1>"
          end
        end
      end

      it "sends both text and html" do
        expect(emails).to receive(:send).with(
          from: "sender@example.com",
          to: ["recipient@example.com"],
          subject: "Hello",
          html: "<h1>HTML</h1>",
          text: "Plain text"
        )

        delivery_method.deliver!(mail)
      end
    end

    context "with multiple recipients" do
      let(:mail) do
        Mail.new do
          from    "sender@example.com"
          to      ["one@example.com", "two@example.com"]
          subject "Hello"
          body    "Hi all"
        end
      end

      it "sends to all recipients" do
        expect(emails).to receive(:send).with(
          from: "sender@example.com",
          to: ["one@example.com", "two@example.com"],
          subject: "Hello",
          text: "Hi all"
        )

        delivery_method.deliver!(mail)
      end
    end

    context "with cc and bcc" do
      let(:mail) do
        Mail.new do
          from    "sender@example.com"
          to      "recipient@example.com"
          cc      "cc@example.com"
          bcc     "bcc@example.com"
          subject "Hello"
          body    "Hi"
        end
      end

      it "includes cc and bcc" do
        expect(emails).to receive(:send).with(
          from: "sender@example.com",
          to: ["recipient@example.com"],
          subject: "Hello",
          text: "Hi",
          cc: ["cc@example.com"],
          bcc: ["bcc@example.com"]
        )

        delivery_method.deliver!(mail)
      end
    end

    context "with reply_to" do
      let(:mail) do
        Mail.new do
          from     "sender@example.com"
          to       "recipient@example.com"
          reply_to "reply@example.com"
          subject  "Hello"
          body     "Hi"
        end
      end

      it "includes reply_to" do
        expect(emails).to receive(:send).with(
          from: "sender@example.com",
          to: ["recipient@example.com"],
          subject: "Hello",
          text: "Hi",
          reply_to: ["reply@example.com"]
        )

        delivery_method.deliver!(mail)
      end
    end
  end

  describe "client configuration" do
    context "with custom settings" do
      let(:settings) { { api_key: "custom_key", base_url: "https://custom.api" } }

      it "passes settings to client" do
        expect(MailJunky::Client).to receive(:new).with(
          api_key: "custom_key",
          base_url: "https://custom.api"
        ).and_return(client)

        mail = Mail.new(from: "a@b.com", to: "c@d.com", subject: "Hi", body: "x")
        delivery_method.deliver!(mail)
      end
    end

    context "without settings" do
      let(:settings) { {} }

      it "uses default configuration" do
        expect(MailJunky::Client).to receive(:new).with(no_args).and_return(client)

        mail = Mail.new(from: "a@b.com", to: "c@d.com", subject: "Hi", body: "x")
        delivery_method.deliver!(mail)
      end
    end
  end
end
