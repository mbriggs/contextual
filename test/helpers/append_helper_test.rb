require "test_helper"

class AppendHelperTest < ActionView::TestCase
  include AppendHelper

  test "append_data! adds data attribute" do
    kwargs = {}
    result = append_data!(:test, "value", kwargs)

    assert_equal({ data: { test: "value" } }, kwargs)
    assert_equal({ test: "value" }, result)
  end

  test "append_data! preserves existing data" do
    kwargs = { data: { existing: "value" } }
    append_data!(:new_attr, "new_value", kwargs)

    assert_equal({ data: { existing: "value", new_attr: "new_value" } }, kwargs)
  end

  test "append_value! creates dasherized data attribute" do
    kwargs = {}
    append_value!(:confirm_message, "Are you sure?", kwargs)

    assert_equal({ data: { "confirm-message-value" => "Are you sure?" } }, kwargs)
  end

  test "append_class! adds classes" do
    kwargs = {}
    append_class!(kwargs, "btn", "btn-primary")

    assert_equal "btn btn-primary", kwargs[:class]
  end

  test "append_class! preserves existing classes" do
    kwargs = { class: "existing" }
    append_class!(kwargs, "new-class")

    assert_equal "existing new-class", kwargs[:class]
  end

  test "append_class! handles nil and empty values" do
    kwargs = { class: "existing" }
    append_class!(kwargs, nil, "", "valid")

    assert_equal "existing valid", kwargs[:class]
  end

  test "disable_prefetch! sets turbo_prefetch to false" do
    kwargs = {}
    disable_prefetch!(kwargs)

    assert_equal({ data: { "turbo_prefetch" => "false" } }, kwargs)
  end

  test "append_confirm! with true adds controller" do
    kwargs = {}
    append_confirm!(kwargs, true)

    assert_equal({ data: { controller: "confirm", "turbo_prefetch" => "false" } }, kwargs)
  end

  test "append_confirm! with false does nothing" do
    kwargs = {}
    append_confirm!(kwargs, false)

    assert_empty(kwargs)
  end

  test "append_confirm! with string adds controller and message" do
    kwargs = {}
    append_confirm!(kwargs, "Are you sure?")

    expected = {
      data: {
        controller: "confirm",
        "turbo_prefetch" => "false",
        "confirm-message-value" => "Are you sure?",
      },
    }

    assert_equal expected, kwargs
  end

  test "append_controller! adds single controller" do
    kwargs = {}
    result = append_controller!("test", kwargs)

    assert_equal({ data: { controller: "test" } }, kwargs)
    assert_equal kwargs, result
  end

  test "append_controller! adds to existing string controller" do
    kwargs = { data: { controller: "existing" } }
    append_controller!("new", kwargs)

    assert_equal({ data: { controller: ["existing", "new"] } }, kwargs)
  end

  test "append_controller! adds to existing array controller" do
    kwargs = { data: { controller: ["first", "second"] } }
    append_controller!("third", kwargs)

    assert_equal({ data: { controller: ["first", "second", "third"] } }, kwargs)
  end

  test "classnames combines classes correctly" do
    result = send(:classnames, "btn", "btn-primary", nil, "", "active")

    assert_equal "btn btn-primary active", result
  end

  test "classnames handles arrays" do
    result = send(:classnames, ["btn", "btn-primary"], "active")

    assert_equal "btn btn-primary active", result
  end

  test "classnames handles empty input" do
    result = send(:classnames)

    assert_equal "", result
  end
end
