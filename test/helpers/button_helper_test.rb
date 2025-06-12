require "test_helper"

class ButtonHelperTest < ActionView::TestCase
  test "button_link with default primary variant" do
    result = button_link("Click me", "/test")

    assert_includes result, 'href="/test"'
    assert_includes result, "Click me"
    assert_includes result, "bg-blue-600"
    assert_includes result, "hover:bg-blue-700"
    assert_includes result, "text-white"
  end

  test "button_link with secondary variant" do
    result = button_link("Click me", "/test", variant: :secondary)

    assert_includes result, "bg-white"
    assert_includes result, "text-gray-700"
    assert_includes result, "border-gray-300"
  end

  test "button_link with danger variant" do
    result = button_link("Delete", "/test", variant: :danger)

    assert_includes result, "bg-red-600"
    assert_includes result, "hover:bg-red-700"
  end

  test "button_link with success variant" do
    result = button_link("Save", "/test", variant: :success)

    assert_includes result, "bg-green-600"
    assert_includes result, "hover:bg-green-700"
  end

  test "button_link with small size" do
    result = button_link("Small", "/test", size: :small)

    assert_includes result, "px-2 py-1"
    assert_includes result, "text-sm"
  end

  test "button_link with large size" do
    result = button_link("Large", "/test", size: :large)

    assert_includes result, "px-4 py-2"
  end

  test "button_link with additional classes" do
    result = button_link("Test", "/test", class: "custom-class")

    assert_includes result, "custom-class"
    assert_includes result, "bg-blue-600"
  end

  test "button_link with data attributes" do
    result = button_link("Test", "/test", data: { turbo_method: :delete })

    assert_includes result, 'data-turbo-method="delete"'
  end

  test "button_link with method parameter converts to turbo_method" do
    result = button_link("Delete", "/test", method: :delete)

    assert_includes result, 'data-turbo-method="delete"'
  end

  test "button_link with method get does not add turbo_method" do
    result = button_link("View", "/test", method: :get)

    assert_not_includes result, "data-turbo-method"
  end

  test "button_link without method does not add turbo_method" do
    result = button_link("View", "/test")

    assert_not_includes result, "data-turbo-method"
  end

  test "button_classes with full_width_mobile adds responsive width classes" do
    result = button_classes(full_width_mobile: true)

    assert_includes result, "w-full sm:w-auto"
  end

  test "button_classes without full_width_mobile does not add width classes" do
    result = button_classes

    assert_not_includes result, "w-full"
  end

  test "button_link with confirm parameter converts to turbo_confirm" do
    result = button_link("Delete", "/test", confirm: "Are you sure?")

    assert_includes result, 'data-turbo-confirm="Are you sure?"'
  end

  test "button_link without confirm does not add turbo_confirm" do
    result = button_link("View", "/test")

    assert_not_includes result, "data-turbo-confirm"
  end
end
