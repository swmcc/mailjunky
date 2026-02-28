# MailJunky Ruby SDK

[![CI](https://github.com/swmcc/mailjunky/actions/workflows/ci.yml/badge.svg)](https://github.com/swmcc/mailjunky/actions/workflows/ci.yml)
[![Ruby](https://img.shields.io/badge/ruby-3.0%2B-red)](https://www.ruby-lang.org)
[![License](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

Ruby SDK for [MailJunky](https://mailjunky.ai) - Email API with AI-Powered Workflows.

[![MailJunky](docs/assets/images/mailjunky-hero.png)](https://mailjunky.ai)

**[Documentation](https://swmcc.github.io/mailjunky)** | **[API Reference](https://mailjunky.ai/api-reference)** | **[Get API Key](https://mailjunky.ai)**

## Installation

```ruby
gem "mailjunky", git: "https://github.com/swmcc/mailjunky.git"
```

## Quick Start

```ruby
require "mailjunky"

client = MailJunky::Client.new(api_key: ENV["MAILJUNKY_API_KEY"])

client.emails.send(
  from: "hello@yourapp.com",
  to: "user@example.com",
  subject: "Welcome!",
  html: "<h1>Welcome aboard</h1>"
)
```

## Features

- **Emails** - Send transactional emails with full control
- **Contacts** - Manage contacts with tags and properties
- **Events** - Track user behaviour for AI-powered workflows
- **Rails** - Action Mailer integration out of the box

## Rails Integration

```ruby
# config/environments/production.rb
config.action_mailer.delivery_method = :mailjunky
config.action_mailer.mailjunky_settings = {
  api_key: Rails.application.credentials.dig(:mailjunky, :api_key)
}
```

Your existing mailers just work. No changes needed.

## Documentation

Full documentation available at **[swmcc.github.io/mailjunky](https://swmcc.github.io/mailjunky)**

- [Getting Started](https://swmcc.github.io/mailjunky/getting-started.html)
- [Sending Emails](https://swmcc.github.io/mailjunky/emails.html)
- [Managing Contacts](https://swmcc.github.io/mailjunky/contacts.html)
- [Tracking Events](https://swmcc.github.io/mailjunky/events.html)
- [Rails Integration](https://swmcc.github.io/mailjunky/rails.html)
- [Error Handling](https://swmcc.github.io/mailjunky/errors.html)

## Development

```
make install   # Install dependencies
make test      # Run tests
make lint      # Run RuboCop
make check     # Run all checks
make docs      # Run docs site locally
```

## License

MIT
