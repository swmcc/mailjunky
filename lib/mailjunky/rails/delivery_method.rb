# frozen_string_literal: true

module MailJunky
  module Rails
    class DeliveryMethod
      attr_reader :settings

      def initialize(settings = {})
        @settings = settings
      end

      def deliver!(mail)
        client.emails.send(**build_params(mail))
      end

      private

      def client
        @client ||= MailJunky::Client.new(**client_options)
      end

      def client_options
        options = {}
        options[:api_key] = settings[:api_key] if settings[:api_key]
        options[:base_url] = settings[:base_url] if settings[:base_url]
        options
      end

      def build_params(mail)
        params = {
          from: extract_address(mail.from),
          to: extract_addresses(mail.to),
          subject: mail.subject
        }

        params[:html] = mail.html_part&.body&.to_s if mail.html_part
        params[:text] = mail.text_part&.body&.to_s if mail.text_part
        params[:text] = mail.body.to_s if !mail.html_part && !mail.text_part && mail.body

        params[:cc] = extract_addresses(mail.cc) if mail.cc&.any?
        params[:bcc] = extract_addresses(mail.bcc) if mail.bcc&.any?
        params[:reply_to] = extract_addresses(mail.reply_to) if mail.reply_to&.any?

        params.compact
      end

      def extract_address(addresses)
        Array(addresses).first
      end

      def extract_addresses(addresses)
        Array(addresses)
      end
    end
  end
end
