# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Managing contacts" do
  let(:client) { MailJunky::Client.new(api_key: "mj_test_123") }

  describe "client.contacts.list" do
    before do
      stub_request(:get, "https://api.mailjunky.ai/api/v1/contacts")
        .to_return(
          status: 200,
          body: { data: [{ id: "ct_123", email: "user@example.com" }], total: 1 }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "returns a list of contacts" do
      response = client.contacts.list

      expect(response["data"].length).to eq(1)
      expect(response["data"].first["email"]).to eq("user@example.com")
    end

    it "makes the correct request" do
      client.contacts.list

      expect(WebMock).to have_requested(:get, "https://api.mailjunky.ai/api/v1/contacts")
        .with(
          headers: {
            "Authorization" => "Bearer mj_test_123",
            "Content-Type" => "application/json"
          }
        )
    end
  end

  describe "client.contacts.get" do
    before do
      stub_request(:get, "https://api.mailjunky.ai/api/v1/contacts/ct_123")
        .to_return(
          status: 200,
          body: { id: "ct_123", email: "user@example.com", first_name: "John" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "returns the contact" do
      response = client.contacts.get(id: "ct_123")

      expect(response["id"]).to eq("ct_123")
      expect(response["first_name"]).to eq("John")
    end
  end

  describe "client.contacts.create" do
    before do
      stub_request(:post, "https://api.mailjunky.ai/api/v1/contacts")
        .to_return(
          status: 200,
          body: { id: "ct_123", email: "user@example.com" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "creates a contact and returns the response" do
      response = client.contacts.create(
        email: "user@example.com",
        first_name: "John",
        last_name: "Doe"
      )

      expect(response["id"]).to eq("ct_123")
    end

    it "makes the correct request" do
      client.contacts.create(
        email: "user@example.com",
        first_name: "John"
      )

      expect(WebMock).to have_requested(:post, "https://api.mailjunky.ai/api/v1/contacts")
        .with(
          body: hash_including(
            "email" => "user@example.com",
            "first_name" => "John"
          ),
          headers: {
            "Authorization" => "Bearer mj_test_123",
            "Content-Type" => "application/json"
          }
        )
    end
  end

  describe "client.contacts.upsert" do
    before do
      stub_request(:post, "https://api.mailjunky.ai/api/v1/contacts/upsert")
        .to_return(
          status: 200,
          body: { id: "ct_123", email: "user@example.com" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "upserts a contact" do
      response = client.contacts.upsert(email: "user@example.com")

      expect(response["id"]).to eq("ct_123")
    end
  end

  describe "client.contacts.update" do
    before do
      stub_request(:patch, "https://api.mailjunky.ai/api/v1/contacts/ct_123")
        .to_return(
          status: 200,
          body: { id: "ct_123", first_name: "Jane" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "updates a contact" do
      response = client.contacts.update(id: "ct_123", first_name: "Jane")

      expect(response["first_name"]).to eq("Jane")
    end
  end

  describe "client.contacts.delete" do
    before do
      stub_request(:delete, "https://api.mailjunky.ai/api/v1/contacts/ct_123")
        .to_return(
          status: 200,
          body: { deleted: true }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "deletes a contact" do
      response = client.contacts.delete(id: "ct_123")

      expect(response["deleted"]).to be true
    end
  end

  describe "client.contacts.batch" do
    before do
      stub_request(:post, "https://api.mailjunky.ai/api/v1/contacts/batch")
        .to_return(
          status: 200,
          body: { created: 2, updated: 0 }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "batch creates contacts" do
      response = client.contacts.batch(
        contacts: [
          { email: "user1@example.com" },
          { email: "user2@example.com" }
        ]
      )

      expect(response["created"]).to eq(2)
    end
  end

  describe "error handling" do
    it "raises NotFoundError for missing contact" do
      stub_request(:get, "https://api.mailjunky.ai/api/v1/contacts/ct_invalid")
        .to_return(status: 404, body: { message: "Contact not found" }.to_json)

      expect do
        client.contacts.get(id: "ct_invalid")
      end.to raise_error(MailJunky::NotFoundError, "Contact not found")
    end

    it "raises ValidationError for invalid data" do
      stub_request(:post, "https://api.mailjunky.ai/api/v1/contacts")
        .to_return(status: 422, body: { message: "Email is invalid" }.to_json)

      expect do
        client.contacts.create(email: "invalid")
      end.to raise_error(MailJunky::ValidationError, "Email is invalid")
    end
  end
end
