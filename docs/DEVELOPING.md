# Development Guide

This guide covers the day-to-day development workflow for the Contextual Blog application.

## Development Workflow

### Starting Development

```bash
# Start all development services (Rails + Tailwind CSS watcher)
bin/dev

# Or start individually
bin/rails server          # Rails app on :3000
bin/rails tailwindcss:watch  # CSS compilation
```

### Code Quality Workflow

Run these commands before committing:

```bash
# Auto-fix style issues
bundle exec rubocop -A

# Security scan
bundle exec brakeman

# Run test suite
bin/rails test
bin/rails test:system
```

### Database Operations

```bash
# Create and run new migration
bin/rails generate migration AddFieldToModel field:type
bin/rails db:migrate

# Rollback last migration
bin/rails db:rollback

# Reset all data (destructive)
bin/rails db:reset

# Load seed data
bin/rails db:seed
```

## Testing Strategy

### Running Tests

```bash
# All tests except system tests
bin/rails test

# System tests (browser automation)
bin/rails test:system

# Specific test files
bin/rails test test/models/post_test.rb
bin/rails test test/controllers/posts_controller_test.rb

# Single test method
bin/rails test test/models/post_test.rb::test_should_validate_title
```

### Test Coverage

```bash
# Generate coverage report
COVERAGE=true bin/rails test

# View coverage report
open coverage/index.html
```

Target: 90% test coverage minimum.

### Writing Tests

Follow patterns in [docs/TESTING.md](TESTING.md):

- Use Arrange-Act-Assert pattern
- Leverage fixtures for test data
- Use `assert` and `refute` for clarity
- Focus on behavior over implementation

## Tech Stack Overview

### Backend
- **Rails 8.0** - Web framework
- **Ruby 3.3+** - Programming language
- **PostgreSQL** - Primary database
- **Solid Queue** - Background jobs (replaces Sidekiq)
- **Solid Cache** - Caching layer (replaces Redis)
- **Solid Cable** - WebSocket connections (replaces Redis)

### Frontend
- **ERB Templates** - Server-rendered HTML
- **Hotwire Turbo** - SPA-like experience without JavaScript
- **Stimulus** - Minimal JavaScript framework
- **Tailwind CSS** - Utility-first CSS framework
- **Propshaft** - Asset pipeline (replaces Sprockets)

### Rich Content
- **ActionText** - Rich text editing with Trix editor
- **Active Storage** - File uploads and attachments

## Development Patterns

### Authentication
Uses Rails 8 authentication generator (not Devise):

```ruby
# In controllers
before_action :authenticate_admin!

# In views
<% if admin_signed_in? %>
  <%= link_to "Admin", admin_path %>
<% end %>

# Current user
current_user.email_address  # Note: email_address, not email
```

### Models
Standard Rails patterns with modern Rails features:

```ruby
class Post < ApplicationRecord
  # Use enums for status
  enum :status, { draft: 0, published: 1, archived: 2 }
  
  # Scopes for common queries
  scope :published, -> { where(status: :published) }
  scope :recent, -> { order(created_at: :desc) }
  
  # ActionText for rich content
  has_rich_text :content
end
```

### Controllers
RESTful design with Turbo integration:

```ruby
class PostsController < ApplicationController
  def create
    @post = Post.new(post_params)
    
    if @post.save
      redirect_to @post, notice: "Post created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end
end
```

### Views
Hotwire-first approach:

```erb
<%= turbo_frame_tag dom_id(post) do %>
  <div class="bg-white rounded-lg shadow">
    <%= render "post_content", post: post %>
  </div>
<% end %>
```

## Code Quality Standards

### RuboCop Configuration
See `.rubocop.yml` for project-specific rules. Key decisions:

- Disabled most Minitest cops (prefer explicit assertions)
- Nested class/module style enforced
- Inherits from shared configuration

### Security
- **Brakeman** scans for security vulnerabilities
- Strong parameters required for all form inputs
- CSRF protection enabled by default
- Force SSL in production

### Performance
- Database queries optimized with appropriate indexes
- N+1 query prevention with `includes`/`preload`
- Fragment caching for expensive operations
- Asset compilation and compression in production

## Background Jobs

Uses **Solid Queue** (not Sidekiq):

```ruby
# Job definition
class EmailNotificationJob < ApplicationJob
  queue_as :default
  
  def perform(user_id, post_id)
    # Job logic here
  end
end

# Enqueue job
EmailNotificationJob.perform_later(user.id, post.id)

# Recurring jobs configured in config/recurring.yml
```

## Deployment

### Production Checklist
- [ ] Database migrations run
- [ ] Assets precompiled
- [ ] Environment variables set
- [ ] SSL certificates configured
- [ ] Background job workers started

### Environment Variables
Production requires:
- `DATABASE_URL` - Primary database connection
- `RAILS_MASTER_KEY` - Encrypted credentials key
- `REDIS_URL` - If using Redis for sessions (optional)

### Deploy Commands
```bash
# Kamal deployment (if using)
kamal deploy

# Or manual deployment
git push production main
heroku run rails db:migrate
heroku run rails assets:precompile
```

## Debugging

### Rails Console
```bash
# Development
bin/rails console

# Production (careful!)
bin/rails console --environment=production
```

### Logs
```bash
# Development logs
tail -f log/development.log

# Production logs (adjust path)
tail -f log/production.log
```

### Database Console
```bash
# PostgreSQL console
bin/rails dbconsole

# Or directly
psql contextual_development
```

## AI Development

This project is designed for AI-assisted development. See [CLAUDE.md](../CLAUDE.md) for:

- Project-specific AI guidance
- Command reference
- Testing patterns
- Code quality requirements

The documentation is optimized for LLM consumption while remaining human-readable.

## Getting Help

1. Check this documentation first
2. Review Rails guides for framework questions
3. Check project tickets in `tickets/` directory
4. Review git history for context on decisions

## Contributing

1. Create feature branch from `main`
2. Follow test-driven development
3. Run quality tools before committing
4. Use conventional commit messages
5. Keep commits atomic and focused