---
title: Home
layout: home
nav_order: 1
---

# MailJunky Ruby SDK

Ruby SDK for [MailJunky](https://mailjunky.ai) - Email API with AI-Powered Workflows.
{: .fs-6 .fw-300 }

[Get Started]({% link getting-started.md %}){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 }
[View on GitHub](https://github.com/swmcc/mailjunky){: .btn .fs-5 .mb-4 .mb-md-0 }

---

[![MailJunky]({{ site.baseurl }}/assets/images/mailjunky-hero.png)](https://mailjunky.ai)

---

## Quick Start

```ruby
require "mailjunky"

client = MailJunky::Client.new(api_key: ENV["MAILJUNKY_API_KEY"])

# Send an email
client.emails.send(
  from: "hello@yourapp.com",
  to: "user@example.com",
  subject: "Welcome!",
  html: "<h1>Welcome aboard</h1>"
)

# Track an event
client.events.track(
  event: "signup_completed",
  user: "user@example.com"
)
```

## Features

- **Emails** - Send transactional emails with full control over delivery
- **Events** - Track user behaviour for AI-powered workflows
- **Rails** - Action Mailer integration out of the box
- **Contacts** - Manage your contact list (coming soon)

## Compatibility

- Ruby 3.0+
- Rails 7.0, 7.1, 7.2, 8.0, 8.1 (optional)
