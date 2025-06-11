# Setup Guide

This guide covers setting up the Contextual Blog application for development.

## Prerequisites

- **macOS** (Linux/Windows users: adapt Homebrew commands)
- **Homebrew** - Install from [https://brew.sh](https://brew.sh)
- **Ruby 3.3+** - Managed via rbenv/asdf/etc.
- **PostgreSQL** - Will be installed via Homebrew

## Quick Setup

For most developers, the automated setup script handles everything:

```bash
git clone <repository-url>
cd contextual
bin/setup
```

The setup script will:
1. Check for Homebrew
2. Install system dependencies via `brew bundle`
3. Install Ruby gems
4. Create and migrate databases
5. Run code quality checks
6. Start the development server

To set up without starting the server:
```bash
bin/setup --skip-server
```

## Manual Setup

If you prefer manual setup or need to troubleshoot:

### 1. System Dependencies

```bash
# Install Homebrew dependencies
brew bundle install

# Verify PostgreSQL is running
brew services start postgresql
```

### 2. Ruby Dependencies

```bash
bundle install
```

### 3. Database Setup

```bash
# Create databases (development, test, queue, cache, cable)
bin/rails db:create

# Run migrations for all databases
bin/rails db:migrate

# Optional: Load seed data
bin/rails db:seed
```

### 4. Verify Installation

```bash
# Run code quality checks
bundle exec rubocop -A
bundle exec brakeman

# Run test suite
bin/rails test
bin/rails test:system

# Start development server
bin/dev
```

## Database Configuration

The application uses multiple PostgreSQL databases:

- **Primary** (`contextual_development`) - Application data
- **Test** (`contextual_test`) - Test isolation
- **Queue** (`contextual_queue_development`) - Background jobs via Solid Queue
- **Cache** (`contextual_cache_development`) - Caching via Solid Cache
- **Cable** (`contextual_cable_development`) - WebSocket connections via Solid Cable

All databases are automatically created and configured by the setup process.

## Troubleshooting

### PostgreSQL Issues

```bash
# Start PostgreSQL if not running
brew services start postgresql

# Check if PostgreSQL is accepting connections
psql -d postgres -c "SELECT version();"
```

### Bundle Install Issues

```bash
# If libpq (PostgreSQL) issues on macOS
bundle config build.pg --with-pg-config=/opt/homebrew/bin/pg_config
bundle install
```

### Permission Issues

```bash
# Make setup script executable
chmod +x bin/setup
```

### Port Conflicts

The development server runs on port 3000 by default. If you have conflicts:

```bash
# Check what's using port 3000
lsof -i :3000

# Kill the process if needed
kill -9 <PID>
```

## Next Steps

After setup is complete:

1. Visit [http://localhost:3000](http://localhost:3000) to see the application
2. Read [docs/DEVELOPING.md](DEVELOPING.md) for development workflow
3. Check [docs/TESTING.md](TESTING.md) for testing guidelines
4. Review [CLAUDE.md](../CLAUDE.md) for AI assistant guidance

## Environment Variables

No environment variables are required for development. The application uses Rails defaults and database configuration from `config/database.yml`.

For production deployment, see the deployment section in [docs/DEVELOPING.md](DEVELOPING.md).