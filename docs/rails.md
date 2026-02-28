---
title: Rails
layout: default
nav_order: 5
---

# Rails Integration

MailJunky works with Action Mailer out of the box. Tested on Rails 7.0, 7.1, 7.2, 8.0, and 8.1.

## Setup

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

## Usage

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

No changes to your mailers needed.

## Development

For development, you might want to use a different delivery method:

```ruby
# config/environments/development.rb
config.action_mailer.delivery_method = :letter_opener
```

Or use MailJunky in test mode:

```ruby
# config/environments/development.rb
config.action_mailer.delivery_method = :mailjunky
config.action_mailer.mailjunky_settings = {
  api_key: ENV["MAILJUNKY_TEST_API_KEY"]
}
```
