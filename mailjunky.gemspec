# frozen_string_literal: true

require_relative "lib/mailjunky/version"

Gem::Specification.new do |spec|
  spec.name = "mailjunky"
  spec.version = MailJunky::VERSION
  spec.authors = ["Stephen McCullough"]
  spec.email = ["me@swm.cc"]

  spec.summary = "Ruby SDK for MailJunky"
  spec.description = "Send transactional emails, track events, and manage contacts with MailJunky."
  spec.homepage = "https://github.com/swmcc/mailjunky-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.glob("lib/**/*") + %w[README.md LICENSE.txt CHANGELOG.md]
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", ">= 1.0", "< 3.0"

  spec.add_development_dependency "actionmailer", ">= 7.0"
  spec.add_development_dependency "appraisal", "~> 2.5"
  spec.add_development_dependency "mail", "~> 2.8"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "rubocop", "~> 1.50"
  spec.add_development_dependency "webmock", "~> 3.18"
end
