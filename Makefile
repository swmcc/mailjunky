APP_NAME := mailjunky
GREEN := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
RESET := $(shell tput -Txterm sgr0)

.DEFAULT_GOAL := help

# 🧩 Development

install: ## Install dependencies
	bundle install

console: ## Open IRB with gem loaded
	bundle exec irb -r mailjunky

# 🧪 Testing

test: ## Run all tests
	bundle exec rspec

test.unit: ## Run unit tests only
	bundle exec rspec spec/unit

test.integration: ## Run integration tests only
	bundle exec rspec spec/integration

# 🔍 Linting

lint: ## Run RuboCop
	bundle exec rubocop

lint.fix: ## Run RuboCop with auto-fix
	bundle exec rubocop -A

# 📦 Build

build: ## Build the gem
	gem build mailjunky.gemspec

clean: ## Clean build artifacts
	rm -f *.gem

# ✅ CI

check: lint test ## Run all checks (lint + test)
	@echo "$(GREEN)✓ All checks passed$(RESET)"

# 📖 Help

help: ## Show all available make targets
	@echo "$(GREEN)$(APP_NAME) - Available targets:$(RESET)"
	@grep -E '^[a-zA-Z0-9_.-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-20s$(RESET) %s\n", $$1, $$2}'

.PHONY: install console test test.unit test.integration lint lint.fix build clean check help
