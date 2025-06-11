namespace :coverage do
  desc "Merge SimpleCov coverage results from parallel test runs"
  task merge: :environment do
    require "simplecov"

    puts "Merging SimpleCov coverage results..."

    # Merge all .resultset*.json files in coverage directory
    result_files = Dir["coverage/.resultset*.json"]

    if result_files.empty?
      puts "No coverage result files found in coverage/ directory"
      exit 1
    end

    puts "Found #{result_files.length} result files:"
    result_files.each { |file| puts "  - #{file}" }

    SimpleCov.collate result_files do
      minimum_coverage 90

      # Same filters as in test_helper.rb
      add_filter "/test/"
      add_filter "/spec/"

      add_filter do |source_file|
        source_file.filename.include?("app/controllers/application_controller.rb") ||
          source_file.filename.include?("app/helpers/application_helper.rb") ||
          source_file.filename.include?("app/jobs/application_job.rb") ||
          source_file.filename.include?("app/mailers/application_mailer.rb") ||
          source_file.filename.include?("app/channels/application_cable/connection.rb") ||
          source_file.filename.include?("app/mailers/passwords_mailer.rb")
      end
    end

    puts "Coverage report merged and generated in coverage/index.html"
  end

  desc "Generate detailed coverage report"
  task :report => :merge do
    system("bin/coverage-report")
  end
end
