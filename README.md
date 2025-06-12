# Contextual Blog

A modern Rails 8 blog application built with simplicity and performance in mind.

## Tech Stack

- **Rails 8.0** with Ruby 3.3+
- **PostgreSQL** database
- **Solid Queue** for background jobs
- **Solid Cache** for caching
- **Solid Cable** for WebSockets
- **Turbo & Stimulus** for interactivity
- **Tailwind CSS** for styling
- **ActionText** for rich content editing

## Quick Start

```bash
# Setup
bin/setup

# Start development server
bin/dev

# Run tests
bin/rails test
```

## Development Commands

**Setup & Database:**
```bash
bundle install                  # Install dependencies
bin/rails db:create            # Create databases
bin/rails db:migrate           # Run migrations
bin/rails db:seed              # Load seed data
```

**Running the Application:**
```bash
bin/dev                         # Start Rails + Tailwind watch
bin/rails server               # Rails server only
```

**Testing:**
```bash
bin/rails test                 # All tests (90% coverage required)
bin/rails test:system          # System tests
bin/coverage-report            # Detailed coverage analysis
```

**Code Quality:**
```bash
bundle exec rubocop -A         # Auto-fix linting (required)
bundle exec brakeman           # Security scan
```

## Project Structure

- `app/` - Main application code
- `tickets/` - Development roadmap and requirements
- `docs/` - Human-readable documentation
- `CLAUDE.md` files - LLM-specific documentation

## Authentication

Uses Rails 8 authentication with:
- Single admin user model
- Signed cookie sessions
- Admin-only content management

## Contributing

1. Run `bundle exec rubocop -A` before committing
2. Ensure tests pass with 90% coverage
3. Follow commit message conventions in `CLAUDE.md`
