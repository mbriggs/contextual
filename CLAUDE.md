# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Application Overview

This is a Rails 8.0 application called "Contextual" using:
- PostgreSQL database
- Tailwind CSS for styling
- Hotwire (Turbo + Stimulus) for interactivity
- Solid Cache, Solid Queue, and Solid Cable for caching, background jobs, and WebSockets
- Propshaft for asset pipeline

## Development Commands

### Setup
- `bundle install` - Install Ruby dependencies
- `bin/rails db:create` - Create development and test databases
- `bin/rails db:migrate` - Run database migrations

### Running the Application
- `bin/dev` - Start development server with Foreman (Rails server + Tailwind watch)
- `bin/rails server` - Start Rails server only
- `bin/rails tailwindcss:watch` - Watch and rebuild Tailwind CSS

### Testing
- `bin/rails test` - Run all tests except system tests
- `bin/rails test:system` - Run system tests with Capybara/Selenium
- `bin/rails test:db` - Reset database and run tests

### Code Quality
- `bundle exec rubocop` - Run Ruby linting with Rails Omakase style guide
- `bundle exec rubocop -a` - Auto-fix linting issues
- `bundle exec brakeman` - Run security vulnerability analysis

## Architecture Notes

- Uses Rails 8.0 modern stack with Solid* adapters instead of Redis
- Tailwind is configured to watch for changes during development
- Health check endpoint available at `/up`
- PWA manifest templates are available but commented out in routes
- Standard Rails MVC structure with Stimulus controllers for JavaScript

## File Structure

- `app/javascript/controllers/` - Stimulus controllers
- `app/assets/tailwind/application.css` - Tailwind entry point
- `config/deploy.yml` - Kamal deployment configuration
- `Procfile.dev` - Development process definitions