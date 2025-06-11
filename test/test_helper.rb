ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/mock"
require "simplecov"

SimpleCov.start "rails" do
  minimum_coverage 90

  # TODO: Remove these as they are implemented
  # Exclude base application files that don't have functionality yet
  add_filter do |source_file|
    source_file.filename.include?("app/controllers/application_controller.rb") ||
      source_file.filename.include?("app/helpers/application_helper.rb") ||
      source_file.filename.include?("app/jobs/application_job.rb") ||
      source_file.filename.include?("app/mailers/application_mailer.rb") ||
      source_file.filename.include?("app/channels/application_cable/connection.rb")
  end
end

# Load all files from test/support
Rails.root.glob("test/support/**/*.rb").each { |f| require f }

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Generic validation helper
    def assert_requires(model, *fields)
      refute model.valid?, "#{model.class} should be invalid without required fields"
      fields.each do |field|
        field_errors = model.errors[field]

        assert field_errors.include?("can't be blank") || field_errors.include?("must exist"),
               "#{field.to_s.humanize} should have 'can't be blank' or 'must exist' error, got: #{field_errors.to_a}"
      end
    end

    # Format validation helper
    def assert_invalid_format(model, field, invalid_value, valid_value = nil)
      original_value = model.send(field)

      # Test invalid format
      model.send("#{field}=", invalid_value)

      refute model.valid?, "#{model.class} should be invalid with #{field}: '#{invalid_value}'"
      assert model.errors[field].any?, "#{field.to_s.humanize} format error should be present"

      # Test valid format if provided
      if valid_value
        model.send("#{field}=", valid_value)
        model.errors.clear

        assert model.valid?, "#{model.class} should be valid with #{field}: '#{valid_value}'"
      end

      # Restore original value
      model.send("#{field}=", original_value)
    end

    # Enum testing helper
    def assert_enum_values(model, field, *values)
      values.each do |value|
        model.send("#{field}=", value)

        assert model.valid?, "#{model.class} should be valid with #{field}: #{value}"
        assert model.send("#{value}?"), "#{value}? should return true when #{field} is #{value}"
      end
    end

    # Scope testing helper
    def assert_scope_filters(scope, included_records, excluded_records)
      result = scope.to_a

      Array(included_records).each do |record|
        assert result.include?(record), "Scope should include #{record.class}##{record.id}"
      end

      Array(excluded_records).each do |record|
        refute result.include?(record), "Scope should exclude #{record.class}##{record.id}"
      end
    end
  end
end
