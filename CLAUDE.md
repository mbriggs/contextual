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

## DOCUMENTATION GUIDELINES

- the docs folder is for human audience documentation
- CLAUDE.md files in folders are for LLM documentation for the files in that folder

## PROJECT MANAGEMENT [TICKETS SYSTEM]

### Tickets Directory Structure
The `tickets/` directory contains the complete project roadmap and development plan:

- **ARCHITECTURE.md** - High-level system design and technical decisions
- **REQUIREMENTS.md** - Detailed feature requirements and acceptance criteria  
- **STATUS.md** - Current ticket completion status (update as work progresses)
- **README.md** - Overview of the ticketing system

### Phase Organization
Development is organized into phases with numbered tickets:

- **Phase 0 (Infrastructure)** - `phase0-infrastructure/` - Setup and tooling
- **Phase 1 (Foundation)** - `phase1-foundation/` - Core blog functionality
- **Phase 2 (Enhancement)** - `phase2-enhancement/` - Advanced features
- **Phase 3 (Polish)** - `phase3-polish/` - Nice-to-have features

### Ticket Format [ALWAYS FOLLOW]
Each ticket contains:
- **Size**: S/M/L complexity estimate
- **Dependencies**: Required prerequisite tickets
- **Context**: Links to requirements and architecture decisions
- **Deliverables**: Checkbox list of concrete work items
- **Success Criteria**: Definition of done
- **Technical Notes**: Implementation guidance

### Working with Tickets [CRITICAL WORKFLOW]
1. **Read STATUS.md first** - Check current progress and next ticket
2. **Read the specific ticket** - Understand deliverables and context
3. **Update STATUS.md** - Mark ticket as in progress [~] when starting
4. **Complete all deliverables** - Check off items as you finish them
5. **Mark completed [x]** - Update STATUS.md when ticket is done
6. **Reference ticket in commits** - Use ticket number in commit messages

### Ticket Dependencies [MUST RESPECT]
- Never work on a ticket until its dependencies are completed
- Phase 0 must be completed before Phase 1
- Within phases, respect individual ticket dependencies
- Update STATUS.md to reflect actual completion status