require "test_helper"

class LoggingTest < ActiveSupport::TestCase
  class TestClass
    include Logging
  end

  class AnotherTestClass
    include Logging
  end

  setup do
    TestClass.instance_variable_set(:@logger, nil)
    AnotherTestClass.instance_variable_set(:@logger, nil)
  end

  test "logger creates tagged logger with class name" do
    logger = TestClass.logger

    assert_kind_of ActiveSupport::TaggedLogging, logger
  end

  test "logger caches logger instance" do
    logger1 = TestClass.logger
    logger2 = TestClass.logger

    assert_same logger1, logger2
  end

  test "different classes get different loggers" do
    logger1 = TestClass.logger
    logger2 = AnotherTestClass.logger

    refute_same logger1, logger2
  end

  test "instance delegates to class logger" do
    instance = TestClass.new

    assert_same TestClass.logger, instance.logger
  end

  test "with_test_logger captures output when class is enabled" do
    # Clear any cached logger first to ensure clean test
    TestClass.instance_variable_set(:@logger, nil)

    config = Logging::Taglist.parse("TestClass") # Enables TestClass
    output = StringIO.new

    TestClass.with_test_logger(config, output: output) do |logger, captured_output|
      assert_kind_of Logger, logger
      assert_same output, captured_output

      logger.info("test message")

      assert_includes output.string, "test message"
      assert_includes output.string, "TestClass"
    end
  end

  test "with_test_logger uses provided output stream for testing" do
    TestClass.instance_variable_set(:@logger, nil)

    config = Logging::Taglist.parse("SomeOtherClass") # Doesn't enable TestClass
    output = StringIO.new

    TestClass.with_test_logger(config, output: output) do |logger, _captured_output|
      logger.info("test message")

      # Test helper always captures output regardless of config
      assert_includes output.string, "test message"
    end
  end

  test "with_test_logger restores original logger" do
    original_logger = TestClass.logger
    config = Logging::Taglist.parse("TestClass")

    TestClass.with_test_logger(config) do |logger, _output|
      refute_same original_logger, logger
    end

    assert_same original_logger, TestClass.logger
  end

  test "with_test_logger restores logger even on exception" do
    original_logger = TestClass.logger
    config = Logging::Taglist.parse("TestClass")

    assert_raises(StandardError) do
      TestClass.with_test_logger(config) do |_logger, _output|
        raise StandardError, "test error"
      end
    end

    assert_same original_logger, TestClass.logger
  end

  test "log_string squishes in production" do
    Rails.stub(:env, ActiveSupport::StringInquirer.new("production")) do
      result = TestClass.log_string("  multi\n  line\n  string  ")

      assert_equal "multi line string", result
    end
  end

  test "log_string preserves formatting in development" do
    Rails.stub(:env, ActiveSupport::StringInquirer.new("development")) do
      input = "  multi\n  line\n  string  "
      result = TestClass.log_string(input)

      assert_equal input, result
    end
  end

  test "log_hash uses inspect in production" do
    hash = { key: "value", nested: { data: 123 } }

    Rails.stub(:env, ActiveSupport::StringInquirer.new("production")) do
      result = TestClass.log_hash(hash)

      assert_equal hash.inspect, result
    end
  end

  test "log_hash uses pretty JSON in development" do
    hash = { key: "value", nested: { data: 123 } }

    Rails.stub(:env, ActiveSupport::StringInquirer.new("development")) do
      result = TestClass.log_hash(hash)

      assert_equal JSON.pretty_generate(hash), result
    end
  end
end

class LoggingTaglistTest < ActiveSupport::TestCase
  test "parse handles single class inclusion" do
    taglist = Logging::Taglist.parse("MyClass")

    assert taglist.include?("MyClass")
    refute taglist.include?("OtherClass")
    refute taglist.exclude?("MyClass")
  end

  test "parse handles class exclusion with minus prefix" do
    taglist = Logging::Taglist.parse("-MyClass")

    refute taglist.include?("MyClass")
    assert taglist.exclude?("MyClass")
  end

  test "parse handles level specification with arrow" do
    taglist = Logging::Taglist.parse("MyClass->debug")

    assert taglist.include?("MyClass")
    assert_equal "debug", taglist.level("MyClass")
  end

  test "parse handles multiple classes" do
    taglist = Logging::Taglist.parse("ClassA,ClassB->info,-ClassC")

    assert taglist.include?("ClassA")
    assert taglist.include?("ClassB")
    assert taglist.exclude?("ClassC")
    assert_equal "info", taglist.level("ClassB")
  end

  test "parse handles _all magic keyword" do
    taglist = Logging::Taglist.parse("_all")

    assert taglist.include?("AnyClass")
    assert taglist.include?("_all")
  end

  test "parse strips whitespace" do
    taglist = Logging::Taglist.parse(" ClassA , ClassB -> debug , -ClassC ")

    assert taglist.include?("ClassA")
    assert taglist.include?("ClassB")
    assert taglist.exclude?("ClassC")
    assert_equal "debug", taglist.level("ClassB")
  end

  test "allow? returns true when included and not excluded" do
    taglist = Logging::Taglist.parse("ClassA,-ClassB,_all")

    assert taglist.allow?("ClassA")
    assert taglist.allow?("RandomClass")  # _all includes it
    refute taglist.allow?("ClassB")       # explicitly excluded
  end

  test "allow? returns false when not included" do
    taglist = Logging::Taglist.parse("ClassA")

    assert taglist.allow?("ClassA")
    refute taglist.allow?("ClassB")
  end

  test "level returns configured level or Rails logger level" do
    Rails.logger.stub(:level, Logger::WARN) do
      taglist = Logging::Taglist.parse("ClassA->debug,ClassB")

      assert_equal "debug", taglist.level("ClassA")
      assert_equal Logger::WARN, taglist.level("ClassB")
      assert_equal Logger::WARN, taglist.level("UnknownClass")
    end
  end

  test "blank creates empty taglist" do
    taglist = Logging::Taglist.blank

    refute taglist.include?("AnyClass")
    refute taglist.exclude?("AnyClass")
    refute taglist.allow?("AnyClass")
  end

  test "from_config uses Rails config when present" do
    Rails.application.config.x.stub(:logging, "TestClass->info") do
      taglist = Logging::Taglist.from_config

      assert taglist.include?("TestClass")
      assert_equal "info", taglist.level("TestClass")
    end
  end

  test "from_config returns blank when config absent" do
    Rails.application.config.x.stub(:logging, nil) do
      taglist = Logging::Taglist.from_config

      refute taglist.allow?("AnyClass")
    end
  end
end
