# CONTEXTUAL BLOG: AI ASSISTANT GUIDELINES

## RUBY PRINCIPLES [HIGHEST PRIORITY]

- ❌ DON'T: Insert `# frozen_string_literal: true` in Ruby files  
- ❌ DON'T: Use `require` statements in app/ files (use Rails autoloading)

## APPLICATION OVERVIEW [CRITICAL]

### Tech Stack [ALWAYS FOLLOW]
- Rails 8.0, Ruby 3.3+, PostgreSQL
- Jobs: Solid Queue (not Sidekiq)
- Caching: Solid Cache (not Redis)  
- Cable: Solid Cable (not Redis)
- Auth: Rails authentication generator (not Devise)
- Frontend: ERB, Turbo, Stimulus, Tailwind CSS
- Assets: Propshaft (not Sprockets)
- Rich Text: ActionText with Active Storage

## DEVELOPMENT COMMANDS [ALWAYS USE THESE]

### Setup Commands
```bash
bundle install                  # Install Ruby dependencies
bin/rails db:create            # Create development and test databases  
bin/rails db:migrate           # Run database migrations
```

### Running Application
```bash
bin/dev                         # Start development server (Rails + Tailwind watch)
bin/rails server               # Start Rails server only
bin/rails tailwindcss:watch    # Watch and rebuild Tailwind CSS
```

### Testing Commands
```bash
bin/rails test                 # Run all tests except system tests
bin/rails test:system          # Run system tests with Capybara/Selenium
bin/rails test test/models/    # Run model tests only
bin/rails test test/controllers/ # Run controller tests only
```

### Code Quality [MANDATORY AFTER ALL CHANGES]
```bash
bundle exec rubocop -A         # Auto-fix linting issues (ALWAYS RUN)
bundle exec brakeman           # Security vulnerability analysis
bin/rails test                 # Ensure all tests pass (90% coverage required)
```

### Database Operations
```bash
bin/rails db:migrate           # Run pending migrations
bin/rails db:rollback          # Rollback last migration
bin/rails db:reset             # Drop, create, and migrate database
bin/rails db:seed              # Load seed data
```

## PROJECT-SPECIFIC STANDARDS [HIGHEST PRIORITY]

### Authentication Setup [PROJECT-SPECIFIC]
- Uses Rails 8 authentication generator (not Devise)
- Single admin user approach
- Helper methods: `current_user`, `authenticate_admin!`, `admin_signed_in?`
- Authentication controller generates User model with `email_address` field (not `email`)

## QUALITY TOOLS [MANDATORY AFTER CHANGES]

### Required Commands
```bash
bundle exec rubocop -A         # Auto-fix linting (ALWAYS RUN)
bundle exec brakeman           # Security scan
bin/rails test                 # Ensure all tests pass
```
