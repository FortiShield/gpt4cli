# Makefile for gpt4cli-1
# A comprehensive build system for the GPT4CLI project

.PHONY: all cli server shared build test install clean dev docker docker-compose-up docker-compose-down help

# Formatting variables #################################
BOLD := $(shell tput -T linux bold)
PURPLE := $(shell tput -T linux setaf 5)
GREEN := $(shell tput -T linux setaf 2)
CYAN := $(shell tput -T linux setaf 6)
RED := $(shell tput -T linux setaf 1)
RESET := $(shell tput -T linux sgr0)
TITLE := $(BOLD)$(PURPLE)
SUCCESS := $(BOLD)$(GREEN)

# Default target #################################
.DEFAULT_GOAL:=help

# Build all components #################################
.PHONY: build
build: cli server  ## Build CLI and server applications

# Build CLI application #################################
.PHONY: cli
cli:  ## Build CLI application only
	@echo "Building CLI application..."
	cd app/cli && go build -o gpt4cli-dev .


.PHONY: server
server:  ## Build server application only
	@echo "Building server application..."
	cd app/server && go build -o gpt4cli-server .

# Build shared library #################################
.PHONY: shared
shared:  ## Build shared library only
	@echo "Building shared library..."
	cd app/shared && go build ./...

# Run tests for all components #################################
.PHONY: test
test:  ## Run tests for all components
	@echo "Running tests for CLI..."
	cd app/cli && go test ./...
	@echo "Running tests for server..."
	cd app/server && go test ./...
	@echo "Running tests for shared..."
	cd app/shared && go test ./...

# Install CLI application #################################
.PHONY: install
install: cli  ## Install CLI application
	@echo "Installing CLI application..."
	@if [ -f app/cli/gpt4cli-dev ]; then \
		sudo cp app/cli/gpt4cli-dev /usr/local/bin/gpt4cli; \
		sudo ln -sf /usr/local/bin/gpt4cli /usr/local/bin/g4c; \
		echo "✅ CLI installed successfully as 'gpt4cli' and 'g4c'"; \
	else \
		echo "❌ CLI binary not found. Run 'make cli' first to build it."; \
		exit 1; \
	fi

# Clean build artifacts #################################
.PHONY: clean
clean:  ## Clean build artifacts
	@echo "Cleaning build artifacts..."
	rm -f app/cli/gpt4cli-dev
	rm -f app/server/gpt4cli-server
	@echo "Clean complete!"

# Development mode with hot reload #################################
.PHONY: dev
dev:  ## Start development mode with hot reload
	@echo "Starting development mode with hot reload..."
	cd app/scripts && ./dev.sh

# Build Docker image for server #################################
.PHONY: docker
docker:  ## Build Docker image for server
	@echo "Building Docker image for server..."
	cd app/server && docker build -t gpt4cli-server .

# Start services with docker-compose #################################
.PHONY: docker-compose-up
docker-compose-up:  ## Start services with docker-compose
	@echo "Starting services with docker-compose..."
	cd app/shared && docker-compose up -d

# Stop services with docker-compose #################################
.PHONY: docker-compose-down
docker-compose-down:  ## Stop services with docker-compose
	@echo "Stopping services with docker-compose..."
	cd app/shared && docker-compose down

# Format Go code #################################
.PHONY: fmt
fmt:  ## Format Go code
	@echo "Formatting Go code..."
	cd app/cli && go fmt ./...
	cd app/server && go fmt ./...
	cd app/shared && go fmt ./...

# Lint Go code #################################
.PHONY: lint
lint:  ## Lint Go code
	@echo "Linting Go code..."
	@if command -v golangci-lint >/dev/null 2>&1; then \
		cd app/cli && golangci-lint run; \
		cd app/server && golangci-lint run; \
		cd app/shared && golangci-lint run; \
	else \
		echo "⚠️  golangci-lint not found. Install it with: go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest"; \
	fi

# Check for outdated dependencies #################################
.PHONY: deps-check
deps-check:  ## Check for outdated dependencies
	@echo "Checking for outdated dependencies..."
	cd app/cli && go list -u -m all
	cd app/server && go list -u -m all
	cd app/shared && go list -u -m all

# Update dependencies #################################
.PHONY: deps-update
deps-update:  ## Update dependencies
	@echo "Updating dependencies..."
	cd app/cli && go get -u ./...
	cd app/server && go get -u ./...
	cd app/shared && go get -u ./...

# Setup development environment #################################
.PHONY: setup
setup:  ## Setup development environment
	@echo "Setting up development environment..."
	@if ! command -v go >/dev/null 2>&1; then \
		echo "❌ Go is not installed. Please install Go 1.23.3+ first."; \
		exit 1; \
	fi
	@if ! command -v git >/dev/null 2>&1; then \
		echo "❌ Git is not installed. Please install Git first."; \
		exit 1; \
	fi
	@echo "✅ Go and Git are installed"
	@if command -v docker >/dev/null 2>&1; then \
		echo "✅ Docker is available"; \
	else \
		echo "⚠️  Docker not found. You'll need to install PostgreSQL locally."; \
	fi
	@echo "✅ Development environment setup complete!"

# Quick start development #################################
.PHONY: quick-start
quick-start: setup  ## Quick start development environment
	@echo "Starting development environment..."
	@if command -v docker >/dev/null 2>&1; then \
		echo "🚀 Starting with Docker..."; \
		make docker-compose-up; \
	else \
		echo "⚠️  Docker not available. Please set up PostgreSQL manually."; \
		echo "Run: createdb gpt4cli"; \
		echo "Then: export DATABASE_URL='postgres://$(whoami):@localhost:5432/gpt4cli?sslmode=disable'"; \
	fi
	@echo "🔨 Building and installing CLI..."
	make install
	@echo "✅ Development environment ready!"
	@echo "📝 Set environment: export GPT4CLI_ENV=development"
	@echo "🚀 Start development: make dev"

# Interactive development setup #################################
.PHONY: setup-interactive
setup-interactive:  ## Interactive development setup
	@echo "🚀 Starting interactive development setup..."
	@if [ -f "scripts/dev-setup.sh" ]; then \
		./scripts/dev-setup.sh; \
	else \
		echo "❌ Setup script not found. Running basic setup..."; \
		make setup; \
		make install; \
	fi

# Setup environment file #################################
.PHONY: env-setup
env-setup:  ## Setup environment file from example
	@echo "🔧 Setting up environment file..."
	@if [ -f ".env.example" ]; then \
		if [ ! -f ".env" ]; then \
			cp .env.example .env; \
			echo "✅ Created .env from .env.example"; \
			echo "📝 Please edit .env with your API keys and settings"; \
		else \
			echo "⚠️  .env already exists. Skipping..."; \
		fi; \
	else \
		echo "❌ .env.example not found"; \
		exit 1; \
	fi


## Halp! #################################

.PHONY: help
help:  ## Display this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(BOLD)$(CYAN)%-25s$(RESET)%s\n", $$1, $$2}'