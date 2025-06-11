# Ticket 00: Code Quality Setup

**Size**: L  
**Dependencies**: None  

## Context
- **From REQUIREMENTS**: AI-assisted development patterns with clean, understandable code
- **From ARCHITECTURE**: Rails 8 conventions and best practices

## Deliverables
- [ ] Configure RuboCop with Rails Omakase style guide
- [ ] Set up Prettier for additional formatting (JS, CSS, Markdown)
- [ ] Set up Brakeman for security vulnerability analysis
- [ ] Configure SimpleCov for test coverage reporting (90% threshold)
- [ ] Add rails_best_practices gem for Rails-specific quality checks
- [ ] Set up database linting and schema validation
- [ ] Configure rack-mini-profiler for development performance monitoring
- [ ] Add code quality commands to CLAUDE.md
- [ ] Create pre-commit hook setup (optional)

## Success Criteria
Comprehensive code quality suite runs successfully with 90% test coverage threshold and provides actionable feedback for development.

## Technical Notes
- Use `bundle add rubocop-rails-omakase --group development,test`
- Add `bundle add brakeman --group development,test` 
- Add `bundle add simplecov --group test` with 90% minimum coverage
- Add `bundle add rails_best_practices --group development,test`
- Add `bundle add rack-mini-profiler --group development`
- Install Prettier via npm/yarn for JS/CSS/Markdown formatting
- Configure database linting for migration safety and schema consistency
- Set up SimpleCov in test_helper.rb with failure threshold
- Configure .rubocop.yml with Rails Omakase defaults
- Update CLAUDE.md with all quality check commands