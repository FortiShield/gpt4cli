#!/usr/bin/env bash

# GPT4CLI Development Setup Script
# This script helps you quickly set up the development environment

set -e

echo "🚀 GPT4CLI Development Setup"
echo "=============================="

# Check if we're in the right directory
if [ ! -f "Makefile" ]; then
    echo "❌ Error: Makefile not found. Please run this script from the project root directory."
    exit 1
fi

echo "📋 Checking prerequisites..."

# Check Go
if ! command -v go >/dev/null 2>&1; then
    echo "❌ Go is not installed. Please install Go 1.23.3+ first:"
    echo "   https://go.dev/doc/install"
    exit 1
fi

# Check Git
if ! command -v git >/dev/null 2>&1; then
    echo "❌ Git is not installed. Please install Git first."
    exit 1
fi

echo "✅ Prerequisites check passed!"

# Ask user for setup preference
echo ""
echo "Choose your setup option:"
echo "1) Docker-based (recommended) - Fastest setup with PostgreSQL included"
echo "2) Local PostgreSQL - Use your local PostgreSQL installation"
echo "3) CLI only - Just build the CLI without server"
echo ""

read -p "Enter your choice (1-3): " choice

case $choice in
    1)
        echo "🐳 Setting up Docker-based development environment..."
        make quick-start
        ;;
    2)
        echo "🏠 Setting up local PostgreSQL development environment..."
        make setup
        echo ""
        echo "📝 Please ensure PostgreSQL is running and create a database:"
        echo "   createdb gpt4cli"
        echo ""
        echo "📝 Set environment variables:"
        echo "   export DATABASE_URL='postgres://$(whoami):@localhost:5432/gpt4cli?sslmode=disable'"
        echo "   export GOENV=development"
        echo "   export GPT4CLI_ENV=development"
        echo ""
        make install
        ;;
    3)
        echo "🔧 Setting up CLI-only development environment..."
        make setup
        make cli
        make install
        ;;
    *)
        echo "❌ Invalid choice. Please run the script again."
        exit 1
        ;;
esac

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "1. Set development environment: export GPT4CLI_ENV=development"
echo "2. Start development mode: make dev"
echo "3. Test the CLI: gpt4cli-dev --help"
echo ""
echo "📚 For more information, see: docs/docs/development.md"
echo "🛠️  Available commands: make help" 