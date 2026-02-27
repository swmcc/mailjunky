# MailJunky Ruby

Ruby SDK for [MailJunky](https://mailjunky.ai).

## Installation

Add to your Gemfile:

```ruby
gem "mailjunky"
```

Or install directly:

```
gem install mailjunky
```

## Usage

```ruby
require "mailjunky"

client = MailJunky::Client.new(api_key: "mj_live_...")

client.emails.send(
  from: "hello@yourapp.com",
  to: "user@example.com",
  subject: "Welcome!",
  html: "<h1>Welcome aboard</h1>"
)
```

### Configuration

Set a global API key:

```ruby
MailJunky.configure do |config|
  config.api_key = ENV["MAILJUNKY_API_KEY"]
end

# Then create clients without passing the key
client = MailJunky::Client.new
```

Or pass it per-client:

```ruby
client = MailJunky::Client.new(api_key: "mj_live_...")
```

### Sending emails

Basic:

```ruby
client.emails.send(
  from: "hello@yourapp.com",
  to: "user@example.com",
  subject: "Hello",
  html: "<p>Hello there</p>"
)
```

With options:

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

### Tracking events

```ruby
client.events.track(
  event: "subscription_renewed",
  user: "user@example.com",
  properties: { plan: "pro", amount: 99 }
)
```

### Error handling

```ruby
begin
  client.emails.send(...)
rescue MailJunky::AuthenticationError
  # Invalid API key
rescue MailJunky::ValidationError => e
  # Invalid params - check e.body for details
rescue MailJunky::RateLimitError
  # Slow down
rescue MailJunky::APIError => e
  # Something else - check e.status and e.message
end
```

## Rails

Works with Action Mailer out of the box. Tested on Rails 7.0, 7.1, 7.2, 8.0, and 8.1.

### Setup

```ruby
# config/environments/production.rb
config.action_mailer.delivery_method = :mailjunky
config.action_mailer.mailjunky_settings = {
  api_key: ENV["MAILJUNKY_API_KEY"]
}
```

Or use Rails credentials:

```ruby
# config/environments/production.rb
config.action_mailer.delivery_method = :mailjunky
config.action_mailer.mailjunky_settings = {
  api_key: Rails.application.credentials.dig(:mailjunky, :api_key)
}
```

### Usage

Your existing mailers just work:

```ruby
class UserMailer < ApplicationMailer
  def welcome(user)
    @user = user
    mail(to: user.email, subject: "Welcome!")
  end
end

# Send it
UserMailer.welcome(user).deliver_now
UserMailer.welcome(user).deliver_later
```

That's it. No changes to your mailers needed.

## Development

```
make install   # Install dependencies
make test      # Run tests
make lint      # Run RuboCop
make check     # Run both
```

## License

MIT
