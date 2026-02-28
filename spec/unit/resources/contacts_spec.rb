# frozen_string_literal: true

require "spec_helper"

RSpec.describe MailJunky::Resources::Contacts do
  let(:connection) { instance_double(MailJunky::Connection) }
  let(:contacts) { described_class.new(connection) }

  describe "#list" do
    it "gets the contacts endpoint" do
      expect(connection).to receive(:get).with(
        "/api/v1/contacts",
        {}
      ).and_return({ "data" => [], "total" => 0 })

      result = contacts.list

      expect(result["data"]).to eq([])
    end

    it "includes filter params when provided" do
      expect(connection).to receive(:get).with(
        "/api/v1/contacts",
        { page: 2, limit: 10, status: "active" }
      ).and_return({ "data" => [] })

      contacts.list(page: 2, limit: 10, status: "active")
    end

    it "includes email filter when provided" do
      expect(connection).to receive(:get).with(
        "/api/v1/contacts",
        { email: "user@example.com" }
      ).and_return({ "data" => [] })

      contacts.list(email: "user@example.com")
    end

    it "includes tag filter when provided" do
      expect(connection).to receive(:get).with(
        "/api/v1/contacts",
        { tag: "newsletter" }
      ).and_return({ "data" => [] })

      contacts.list(tag: "newsletter")
    end
  end

  describe "#get" do
    it "gets a specific contact by id" do
      expect(connection).to receive(:get).with(
        "/api/v1/contacts/ct_123"
      ).and_return({ "id" => "ct_123", "email" => "user@example.com" })

      result = contacts.get(id: "ct_123")

      expect(result["id"]).to eq("ct_123")
    end
  end

  describe "#create" do
    it "posts to the contacts endpoint with required params" do
      expect(connection).to receive(:post).with(
        "/api/v1/contacts",
        hash_including(email: "user@example.com")
      ).and_return({ "id" => "ct_123", "email" => "user@example.com" })

      result = contacts.create(email: "user@example.com")

      expect(result["email"]).to eq("user@example.com")
    end

    it "includes optional params when provided" do
      expect(connection).to receive(:post).with(
        "/api/v1/contacts",
        hash_including(
          email: "user@example.com",
          first_name: "John",
          last_name: "Doe",
          phone: "+1234567890"
        )
      ).and_return({})

      contacts.create(
        email: "user@example.com",
        first_name: "John",
        last_name: "Doe",
        phone: "+1234567890"
      )
    end

    it "includes properties when provided" do
      expect(connection).to receive(:post).with(
        "/api/v1/contacts",
        hash_including(properties: { company: "Acme", plan: "pro" })
      ).and_return({})

      contacts.create(
        email: "user@example.com",
        properties: { company: "Acme", plan: "pro" }
      )
    end

    it "includes tags when provided" do
      expect(connection).to receive(:post).with(
        "/api/v1/contacts",
        hash_including(tags: %w[newsletter customer])
      ).and_return({})

      contacts.create(
        email: "user@example.com",
        tags: %w[newsletter customer]
      )
    end

    it "excludes nil values from payload" do
      expect(connection).to receive(:post).with(
        "/api/v1/contacts",
        { email: "user@example.com" }
      ).and_return({})

      contacts.create(
        email: "user@example.com",
        first_name: nil,
        last_name: nil
      )
    end
  end

  describe "#upsert" do
    it "posts to the upsert endpoint" do
      expect(connection).to receive(:post).with(
        "/api/v1/contacts/upsert",
        hash_including(email: "user@example.com")
      ).and_return({ "id" => "ct_123" })

      contacts.upsert(email: "user@example.com")
    end

    it "includes all contact fields when provided" do
      expect(connection).to receive(:post).with(
        "/api/v1/contacts/upsert",
        hash_including(
          email: "user@example.com",
          first_name: "John",
          tags: ["vip"]
        )
      ).and_return({})

      contacts.upsert(
        email: "user@example.com",
        first_name: "John",
        tags: ["vip"]
      )
    end
  end

  describe "#update" do
    it "patches a specific contact" do
      expect(connection).to receive(:patch).with(
        "/api/v1/contacts/ct_123",
        hash_including(first_name: "Jane")
      ).and_return({ "id" => "ct_123", "first_name" => "Jane" })

      result = contacts.update(id: "ct_123", first_name: "Jane")

      expect(result["first_name"]).to eq("Jane")
    end

    it "includes status when provided" do
      expect(connection).to receive(:patch).with(
        "/api/v1/contacts/ct_123",
        hash_including(status: "unsubscribed")
      ).and_return({})

      contacts.update(id: "ct_123", status: "unsubscribed")
    end

    it "excludes nil values from payload" do
      expect(connection).to receive(:patch).with(
        "/api/v1/contacts/ct_123",
        { first_name: "Jane" }
      ).and_return({})

      contacts.update(
        id: "ct_123",
        first_name: "Jane",
        last_name: nil
      )
    end
  end

  describe "#delete" do
    it "deletes a specific contact" do
      expect(connection).to receive(:delete).with(
        "/api/v1/contacts/ct_123"
      ).and_return({ "deleted" => true })

      result = contacts.delete(id: "ct_123")

      expect(result["deleted"]).to be true
    end
  end

  describe "#batch" do
    it "posts to the batch endpoint" do
      batch = [
        { email: "user1@example.com", first_name: "User 1" },
        { email: "user2@example.com", first_name: "User 2" }
      ]

      expect(connection).to receive(:post).with(
        "/api/v1/contacts/batch",
        { contacts: batch }
      ).and_return({ "created" => 2, "updated" => 0 })

      result = contacts.batch(contacts: batch)

      expect(result["created"]).to eq(2)
    end
  end
end
