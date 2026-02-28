---
title: Error Handling
layout: default
nav_order: 6
---

# Error Handling

All API errors inherit from `MailJunky::APIError`.

## Error types

| Error | Status | Description |
|:------|:-------|:------------|
| `AuthenticationError` | 401 | Invalid API key |
| `ValidationError` | 422 | Invalid parameters |
| `NotFoundError` | 404 | Resource not found |
| `RateLimitError` | 429 | Too many requests |
| `ServerError` | 5xx | Server error |

## Handling errors

```ruby
begin
  client.emails.send(
    from: "hello@yourapp.com",
    to: "user@example.com",
    subject: "Hello",
    html: "<p>Hi</p>"
  )
rescue MailJunky::AuthenticationError
  # Invalid API key - check your configuration
  Rails.logger.error("MailJunky: Invalid API key")

rescue MailJunky::ValidationError => e
  # Invalid params - check the error details
  Rails.logger.error("MailJunky validation error: #{e.body}")

rescue MailJunky::RateLimitError
  # Back off and retry
  sleep(1)
  retry

rescue MailJunky::APIError => e
  # Catch-all for other API errors
  Rails.logger.error("MailJunky error: #{e.status} - #{e.message}")
end
```

## Error attributes

All `APIError` exceptions have:

- `status` - HTTP status code
- `message` - Error message
- `body` - Full response body (if available)
