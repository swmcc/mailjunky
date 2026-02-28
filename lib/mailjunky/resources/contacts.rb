# frozen_string_literal: true

module MailJunky
  module Resources
    class Contacts < Base
      def list(page: nil, limit: nil, email: nil, tag: nil, status: nil)
        params = {
          page: page,
          limit: limit,
          email: email,
          tag: tag,
          status: status
        }.compact

        connection.get("/api/v1/contacts", params)
      end

      def get(id:)
        connection.get("/api/v1/contacts/#{id}")
      end

      def create(email:, first_name: nil, last_name: nil, phone: nil, properties: nil, tags: nil)
        payload = {
          email: email,
          first_name: first_name,
          last_name: last_name,
          phone: phone,
          properties: properties,
          tags: tags
        }.compact

        connection.post("/api/v1/contacts", payload)
      end

      def upsert(email:, first_name: nil, last_name: nil, phone: nil, properties: nil, tags: nil)
        payload = {
          email: email,
          first_name: first_name,
          last_name: last_name,
          phone: phone,
          properties: properties,
          tags: tags
        }.compact

        connection.post("/api/v1/contacts/upsert", payload)
      end

      def update(id:, first_name: nil, last_name: nil, phone: nil, properties: nil, tags: nil, status: nil)
        payload = {
          first_name: first_name,
          last_name: last_name,
          phone: phone,
          properties: properties,
          tags: tags,
          status: status
        }.compact

        connection.patch("/api/v1/contacts/#{id}", payload)
      end

      def delete(id:)
        connection.delete("/api/v1/contacts/#{id}")
      end

      def batch(contacts:)
        connection.post("/api/v1/contacts/batch", { contacts: contacts })
      end
    end
  end
end
