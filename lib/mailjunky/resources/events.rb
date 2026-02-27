# frozen_string_literal: true

module MailJunky
  module Resources
    class Events < Base
      def track(event:, user: nil, properties: nil, session_id: nil, timestamp: nil)
        payload = {
          event: event,
          user: user,
          properties: properties,
          session_id: session_id,
          timestamp: timestamp
        }.compact

        connection.post("/api/v1/events/track", payload)
      end
    end
  end
end
