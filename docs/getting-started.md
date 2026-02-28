---
title: Getting Started
layout: default
nav_order: 2
---

# Getting Started

## Installation

Add to your Gemfile:

```ruby
gem "mailjunky", git: "https://github.com/swmcc/mailjunky.git"
```

Then run:

```bash
bundle install
```

## Configuration

### Global configuration

Set your API key once:

```ruby
MailJunky.configure do |config|
  config.api_key = ENV["MAILJUNKY_API_KEY"]
end

client = MailJunky::Client.new
```

### Per-client configuration

Or pass it when creating a client:

```ruby
client = MailJunky::Client.new(api_key: "mj_live_...")
```

### Options

| Option | Default | Description |
|:-------|:--------|:------------|
| `api_key` | - | Your MailJunky API key |
| `base_url` | `https://api.mailjunky.ai` | API endpoint |
| `timeout` | `30` | Request timeout in seconds |
| `open_timeout` | `10` | Connection timeout in seconds |

## Next steps

- [Sending emails]({% link emails.md %})
- [Tracking events]({% link events.md %})
- [Rails integration]({% link rails.md %})
