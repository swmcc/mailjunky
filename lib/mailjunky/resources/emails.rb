# frozen_string_literal: true

module MailJunky
  module Resources
    class Emails < Base
      def send(from:, to:, subject:, html: nil, text: nil, **options)
        payload = {
          from: from,
          to: to,
          subject: subject,
          html: html,
          text: text,
          **options
        }.compact

        connection.post("/api/v1/emails/send", payload)
      end

      def send_batch(emails)
        connection.post("/api/v1/emails/batch", { emails: emails })
      end
    end
  end
end
