---
title: Emails
layout: default
nav_order: 3
---

# Emails

Send transactional emails via the MailJunky API.

## Send a single email

```ruby
client.emails.send(
  from: "hello@yourapp.com",
  to: "user@example.com",
  subject: "Welcome!",
  html: "<h1>Welcome aboard</h1>"
)
```

## Parameters

| Parameter | Type | Required | Description |
|:----------|:-----|:---------|:------------|
| `from` | String | Yes | Sender email address |
| `to` | String or Array | Yes | Recipient(s) |
| `subject` | String | Yes | Email subject |
| `html` | String | No | HTML body |
| `text` | String | No | Plain text body |
| `cc` | String or Array | No | CC recipients |
| `bcc` | String or Array | No | BCC recipients |
| `reply_to` | String or Array | No | Reply-to address(es) |
| `tags` | Array | No | Tags for categorization |
| `metadata` | Hash | No | Custom metadata |

## Multiple recipients

```ruby
client.emails.send(
  from: "hello@yourapp.com",
  to: ["user1@example.com", "user2@example.com"],
  cc: "manager@example.com",
  bcc: "records@yourapp.com",
  subject: "Team update",
  html: "<p>Here's what happened...</p>",
  text: "Here's what happened..."
)
```

## Batch sending

Send multiple emails in a single request:

```ruby
client.emails.send_batch([
  {
    from: "hello@yourapp.com",
    to: "user1@example.com",
    subject: "Hello User 1",
    html: "<p>Hi there</p>"
  },
  {
    from: "hello@yourapp.com",
    to: "user2@example.com",
    subject: "Hello User 2",
    html: "<p>Hi there</p>"
  }
])
```
