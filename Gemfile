source "https://rubygems.org"

# Core Rails framework
gem "rails", "~> 8.0.2"

# Database
gem "pg", "~> 1.1"

# Web server
gem "puma", ">= 5.0"

# Asset pipeline and frontend
gem "importmap-rails"
gem "jbuilder"
gem "propshaft"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "turbo-rails"

# Rails 8 Solid adapters (replaces Redis)
gem "solid_cable"
gem "solid_cache"
gem "solid_queue"

# Performance and deployment
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false

# Platform compatibility
gem "tzinfo-data", platforms: [:windows, :jruby]

group :development, :test do
  gem "brakeman", require: false
  gem "debug", platforms: [:mri, :windows], require: "debug/prelude"
  gem "rails_best_practices", "~> 1.23"
end

group :development do
  gem "rack-mini-profiler", "~> 4.0"
  gem "web-console"

  # Code quality and linting
  gem "rubocop"
  gem "rubocop-capybara"
  gem "rubocop-minitest"
  gem "rubocop-performance"
  gem "rubocop-rails"
  gem "rubocop-rails-omakase", require: false
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "simplecov", "~> 0.22.0"
end
