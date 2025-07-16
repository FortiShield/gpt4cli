---
sidebar_position: 10
sidebar_label: Development
---

# Development

This guide provides quick setup options for developing GPT4CLI locally.

## Prerequisites

Before starting, ensure you have the following installed:

- **Go 1.23.3** - [Download here](https://go.dev/doc/install)
- **Git** - For version control
- **Docker & Docker Compose** - For local database and server (optional)

## Quick Setup Options

### Option 1: Docker-based Development (Recommended)

The fastest way to get started with a complete development environment:

```bash
# Clone the repository
git clone <repository-url>
cd gpt4cli-1

# Start the complete development environment
make docker-compose-up

# Build and install the CLI
make install

# Set development environment
export GPT4CLI_ENV=development

# You're ready to develop! 🚀
```

This starts PostgreSQL and the server automatically. The server runs on port 8099.

### Option 2: Local Development with Makefile

For developers who prefer local PostgreSQL:

```bash
# 1. Install dependencies
brew install postgresql  # macOS
# or
sudo apt-get install postgresql postgresql-contrib  # Ubuntu/Debian

# 2. Start PostgreSQL and create database
brew services start postgresql  # macOS
# or
sudo systemctl start postgresql  # Linux

createdb gpt4cli

# 3. Set environment variables
export DATABASE_URL="postgres://$(whoami):@localhost:5432/gpt4cli?sslmode=disable"
export GOENV=development
export GPT4CLI_ENV=development

# 4. Build and install
make install

# 5. Start development server
make dev
```

### Option 3: Minimal Setup (CLI Only)

For CLI development without the server:

```bash
# Build and install CLI only
make cli
make install

# Test the CLI
gpt4cli --help
```

## Development Workflow

### Using the Makefile

The project includes a comprehensive Makefile for common development tasks:

```bash
# Show all available commands
make help

# Build everything
make build

# Run tests
make test

# Format code
make fmt

# Lint code (requires golangci-lint)
make lint

# Start development mode with hot reload
make dev

# Install CLI globally
make install
```

### Development Mode

Start development mode with hot reload:

```bash
make dev
```

This will:
- Watch for file changes in `cli/`, `server/`, and `shared/` directories
- Automatically rebuild the CLI and copy it to `/usr/local/bin/gpt4cli-dev`
- Create a `g4cd` alias for easy access
- Start the server with hot reload

### Environment Variables

Copy the example environment file and configure it:

```bash
# Copy the example environment file
cp .env.example .env

# Edit the .env file with your settings
nano .env  # or use your preferred editor
```

Key variables for development:

```bash
# Required for development
export GOENV=development
export LOCAL_MODE=1
export GPT4CLI_ENV=development

# Database (if not using Docker)
export DATABASE_URL="postgres://user:password@host:5432/gpt4cli?sslmode=disable"

# AI Model API Keys (at least one required)
export OPENAI_API_KEY=your-openai-api-key
export ANTHROPIC_API_KEY=your-anthropic-api-key  # for Claude models
export OPENROUTER_API_KEY=your-openrouter-api-key  # for multiple providers
```

### Database Setup

#### Using Docker (Recommended)

```bash
# Start database and server
make docker-compose-up

# Stop services
make docker-compose-down
```

#### Using Local PostgreSQL

```bash
# Create database
createdb gpt4cli

# Run migrations (if needed)
# The server will handle migrations automatically on startup
```

## Project Structure

```
gpt4cli-1/
├── app/
│   ├── cli/          # CLI application
│   ├── server/       # Server application  
│   ├── shared/       # Shared code
│   └── scripts/      # Development scripts
├── docs/             # Documentation
├── test/             # Test files
└── Makefile          # Build system
```

## Common Development Tasks

### Adding Dependencies

```bash
# Add to CLI
cd app/cli && go get <package>

# Add to Server
cd app/server && go get <package>

# Add to Shared
cd app/shared && go get <package>
```

### Running Tests

```bash
# Run all tests
make test

# Run specific module tests
cd app/cli && go test ./...
cd app/server && go test ./...
```

### Code Quality

```bash
# Format code
make fmt

# Lint code
make lint

# Check for outdated dependencies
make deps-check
```

### Building for Production

```bash
# Build all components
make build

# Build specific component
make cli
make server
```

## Troubleshooting

### Permission Issues

If you encounter permission issues with `/usr/local/bin`:

```bash
# On macOS/Linux
sudo make install

# Or change the install directory
export GPT4CLI_DEV_CLI_OUT_DIR=$HOME/bin
make install
```

### Database Connection Issues

```bash
# Check if PostgreSQL is running
brew services list | grep postgresql  # macOS
sudo systemctl status postgresql      # Linux

# Test database connection
psql $DATABASE_URL -c "SELECT 1;"
```

### Port Conflicts

If port 8099 is already in use:

```bash
# Find what's using the port
lsof -i :8099

# Kill the process or change the port in docker-compose.yml
```

### Development vs Production

- **Development**: Uses `gpt4cli-dev` binary and `g4cd` alias
- **Production**: Uses `gpt4cli` binary and `g4c` alias

This separation prevents conflicts between development and production installations.

## Next Steps

1. **Explore the codebase**: Start with `app/cli/main.go` and `app/server/main.go`
2. **Run the development server**: `make dev`
3. **Test the CLI**: `gpt4cli-dev --help`
4. **Check the documentation**: Browse the `docs/` directory

Happy coding! 🚀
