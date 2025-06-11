ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/mock"
require "simplecov"

SimpleCov.start "rails" do
  minimum_coverage 90
end

# Load all files from test/support
Rails.root.glob("test/support/**/*.rb").each { |f| require f }

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    self.use_transactional_tests = true
  end
end
