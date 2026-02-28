---
title: Contacts
layout: default
nav_order: 5
---

# Contacts

Manage your contacts (recipients) via the MailJunky API.

## List contacts

```ruby
# List all contacts
client.contacts.list

# With pagination
client.contacts.list(page: 2, limit: 50)

# Filter by status
client.contacts.list(status: "active")

# Filter by tag
client.contacts.list(tag: "newsletter")

# Filter by email
client.contacts.list(email: "user@example.com")
```

### List Parameters

| Parameter | Type | Required | Description |
|:----------|:-----|:---------|:------------|
| `page` | Integer | No | Page number (default: 1) |
| `limit` | Integer | No | Results per page (default: 25) |
| `email` | String | No | Filter by email address |
| `tag` | String | No | Filter by tag |
| `status` | String | No | Filter by status (active, unsubscribed) |

## Get a contact

```ruby
client.contacts.get(id: "ct_123")
```

## Create a contact

```ruby
client.contacts.create(
  email: "user@example.com",
  first_name: "John",
  last_name: "Doe",
  phone: "+1234567890",
  properties: {
    company: "Acme Inc",
    plan: "pro"
  },
  tags: ["newsletter", "customer"]
)
```

### Create Parameters

| Parameter | Type | Required | Description |
|:----------|:-----|:---------|:------------|
| `email` | String | Yes | Contact email address |
| `first_name` | String | No | First name |
| `last_name` | String | No | Last name |
| `phone` | String | No | Phone number |
| `properties` | Hash | No | Custom properties |
| `tags` | Array | No | Tags for categorization |

## Upsert a contact

Create or update a contact by email. If a contact with the email exists, it will be updated; otherwise, a new contact is created.

```ruby
client.contacts.upsert(
  email: "user@example.com",
  first_name: "John",
  tags: ["vip"]
)
```

## Update a contact

```ruby
client.contacts.update(
  id: "ct_123",
  first_name: "Jane",
  tags: ["premium"],
  status: "active"
)
```

### Update Parameters

| Parameter | Type | Required | Description |
|:----------|:-----|:---------|:------------|
| `id` | String | Yes | Contact ID |
| `first_name` | String | No | First name |
| `last_name` | String | No | Last name |
| `phone` | String | No | Phone number |
| `properties` | Hash | No | Custom properties |
| `tags` | Array | No | Tags for categorization |
| `status` | String | No | Status (active, unsubscribed) |

## Delete a contact

```ruby
client.contacts.delete(id: "ct_123")
```

## Batch operations

Create or update multiple contacts in a single request:

```ruby
client.contacts.batch(
  contacts: [
    { email: "user1@example.com", first_name: "User 1", tags: ["batch"] },
    { email: "user2@example.com", first_name: "User 2", tags: ["batch"] },
    { email: "user3@example.com", first_name: "User 3", tags: ["batch"] }
  ]
)
```

The batch operation performs an upsert for each contact.
