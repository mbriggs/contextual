# Class-based logging system with granular per-class control.
#
# Usage:
#   class MyClass
#     include Logging
#   end
#
#   MyClass.logger.info("Class-level logging")
#   MyClass.new.logger.info("Instance-level logging")
#
# Configuration:
#   Set config.x.logging in environment files:
#   config.x.logging = "MyClass->debug,OtherClass,-DisabledClass,_all"
#
#   - MyClass->debug: Set MyClass logger to debug level
#   - OtherClass: Enable with Rails.logger level
#   - -DisabledClass: Disable logging (logs to /dev/null)
#   - _all: Enable all unspecified loggers (disabled by default)
#
# Loggers output to STDERR and are tagged with the class name.
module Logging
  extend ActiveSupport::Concern

  # Global configuration management
  def self.config=(val)
    @config = Taglist.parse(val)
  end

  def self.config
    @config ||= Taglist.from_config
  end

  class_methods do
    def logger
      if @logger
        return @logger
      end

      config = Logging.config

      dev = config.allow?(name) ? STDERR : File::NULL

      logger = ActiveSupport::TaggedLogging.new(Logger.new(dev))
      logger.level = config.level(name)
      logger.formatter = Rails.logger.formatter

      @logger ||= logger.tagged(name)
    end

    # Test helper for injecting custom configuration and capturing output
    def with_test_logger(config, output: StringIO.new)
      old_logger = @logger
      @logger = nil

      # For testing, always use the provided output stream regardless of config
      logger = ActiveSupport::TaggedLogging.new(Logger.new(output))
      logger.level = config.level(name)
      logger.formatter = Rails.logger.formatter

      @logger = logger.tagged(name)
      yield @logger, output
    ensure
      @logger = old_logger
    end

    def log_string(string)
      if Rails.env.production?
        string.squish
      else
        string
      end
    end

    def log_hash(hash)
      if Rails.env.production?
        hash.inspect
      else
        JSON.pretty_generate(hash)
      end
    end
  end

  delegate :logger, :log_string, :log_hash,
    to: :class

  class Taglist
    # Parse configuration string into include/exclude rules
    def self.parse(taglist_config)
      include = {}
      exclude = {}

      taglist_config.split(",").each do |tag|
        tag = tag.strip

        level = nil
        if tag.include?("->")
          tag, level = tag.split("->")
          tag = tag.strip
          level = level.strip if level
        end

        if tag.start_with?("-")
          tag = tag[1..].strip
          exclude[tag] = level
        else
          include[tag] = level
        end
      end

      Taglist.new(include: include, exclude: exclude)
    end

    # Empty taglist (disables all loggers)
    def self.blank
      @blank ||= new
    end

    # Build taglist from Rails config.x.logging
    def self.from_config
      config = Rails.application.config.x.logging
      if config.present?
        parse(config)
      else
        blank
      end
    end

    attr_reader :include

    attr_reader :exclude

    def initialize(include: {}, exclude: {})
      @include = include
      @exclude = exclude
    end

    def include?(tag)
      include.key?("_all") || include.key?(tag)
    end

    def exclude?(tag)
      exclude.key?(tag)
    end

    def allow?(*tags)
      tags.any? { |tag| include?(tag) } && !tags.any? { |tag| exclude?(tag) }
    end

    # Get configured level for tag, fallback to Rails.logger level
    def level(tag)
      include[tag] || exclude[tag] || Rails.logger.level
    end
  end
end
