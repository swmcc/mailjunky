---
title: Events
layout: default
nav_order: 4
---

# Events

Track user events for analytics and automation.

## Track an event

```ruby
client.events.track(
  event: "subscription_renewed",
  user: "user@example.com",
  properties: { plan: "pro", amount: 99 }
)
```

## Parameters

| Parameter | Type | Required | Description |
|:----------|:-----|:---------|:------------|
| `event` | String | Yes | Event name |
| `user` | String | No | User identifier (email or ID) |
| `properties` | Hash | No | Event properties/metadata |
| `session_id` | String | No | Session identifier |
| `timestamp` | String | No | ISO 8601 timestamp |

## Examples

### Page view

```ruby
client.events.track(
  event: "page_viewed",
  user: current_user.email,
  properties: {
    path: "/pricing",
    referrer: "https://google.com"
  }
)
```

### Purchase completed

```ruby
client.events.track(
  event: "purchase_completed",
  user: current_user.email,
  properties: {
    order_id: order.id,
    amount: order.total,
    currency: "USD",
    items: order.items.count
  }
)
```

### With timestamp

```ruby
client.events.track(
  event: "signup_completed",
  user: "user@example.com",
  timestamp: Time.now.utc.iso8601
)
```
