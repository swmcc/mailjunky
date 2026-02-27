# frozen_string_literal: true

require "spec_helper"
require "action_mailer"
require "mailjunky/rails"

# Register delivery method (normally done by Railtie)
ActionMailer::Base.add_delivery_method(:mailjunky, MailJunky::Rails::DeliveryMethod)

RSpec.describe "Action Mailer Integration", type: :integration do
  describe "delivery method registration" do
    it "registers :mailjunky as a delivery method" do
      expect(ActionMailer::Base.delivery_methods).to include(:mailjunky)
    end

    it "uses MailJunky::Rails::DeliveryMethod" do
      expect(ActionMailer::Base.delivery_methods[:mailjunky]).to eq(MailJunky::Rails::DeliveryMethod)
    end

    it "allows setting mailjunky_settings" do
      ActionMailer::Base.mailjunky_settings = { api_key: "test_key" }
      expect(ActionMailer::Base.mailjunky_settings).to eq({ api_key: "test_key" })
    end
  end

  describe "delivery via Mail gem" do
    let(:client) { instance_double(MailJunky::Client) }
    let(:emails) { instance_double(MailJunky::Resources::Emails) }
    let(:delivery_method) { MailJunky::Rails::DeliveryMethod.new(api_key: "test_key") }

    before do
      allow(MailJunky::Client).to receive(:new).and_return(client)
      allow(client).to receive(:emails).and_return(emails)
      allow(emails).to receive(:send).and_return({ "id" => "123", "status" => "sent" })
    end

    it "delivers a Mail::Message via mailjunky" do
      mail = Mail.new do
        from    "sender@example.com"
        to      "recipient@example.com"
        subject "Integration test"
        body    "This is a test"
      end

      expect(emails).to receive(:send).with(
        hash_including(
          from: "sender@example.com",
          to: ["recipient@example.com"],
          subject: "Integration test"
        )
      )

      delivery_method.deliver!(mail)
    end

    it "handles multipart emails" do
      mail = Mail.new do
        from    "sender@example.com"
        to      "recipient@example.com"
        subject "Multipart test"

        text_part do
          body "Plain text"
        end

        html_part do
          content_type "text/html; charset=UTF-8"
          body "<h1>HTML</h1>"
        end
      end

      expect(emails).to receive(:send).with(
        hash_including(
          from: "sender@example.com",
          to: ["recipient@example.com"],
          subject: "Multipart test",
          text: "Plain text",
          html: "<h1>HTML</h1>"
        )
      )

      delivery_method.deliver!(mail)
    end
  end
end
