require "test_helper"

class FormHelperTest < ActionView::TestCase
  include FormHelper
  include ButtonHelper

  def setup
    @post = Post.new(title: "Test", content: "Content")
  end

  test "styled_form_with uses custom FormBuilder by default" do
    form_html = styled_form_with(model: @post, local: true) do |form|
      assert_instance_of FormBuilder, form
      ""
    end

    assert_match(/form/, form_html)
  end

  test "text_field generates labeled field by default" do
    form_html = styled_form_with(model: @post, local: true) do |form|
      form.text_field :title
    end

    assert_match(/label.*for.*title/, form_html)
    assert_match(/block text-sm font-medium text-gray-700 mb-2/, form_html)
    assert_match(/w-full px-3 py-2 border border-gray-300/, form_html)
  end

  test "text_field with labeled false uses simple styling" do
    form_html = styled_form_with(model: @post, local: true) do |form|
      form.text_field :title, labeled: false
    end

    assert_no_match(/label.*for.*title/, form_html)
    assert_match(/block shadow-sm rounded-md border border-gray-400/, form_html)
  end

  test "text_area generates labeled field with hint" do
    form_html = styled_form_with(model: @post, local: true) do |form|
      form.text_area :content, hint: "Write your content here"
    end

    assert_match(/label.*for.*content/, form_html)
    assert_match(/Write your content here/, form_html)
    assert_match(/text-sm text-gray-500 mt-1/, form_html)
  end

  test "email_field works with labeled false" do
    form_html = styled_form_with(url: "/test", local: true) do |form|
      form.email_field :email_address, labeled: false, placeholder: "Enter email"
    end

    assert_no_match(/label.*for.*email_address/, form_html)
    assert_match(/placeholder="Enter email"/, form_html)
    assert_match(/block shadow-sm rounded-md/, form_html)
  end

  test "password_field works with labeled false" do
    form_html = styled_form_with(url: "/test", local: true) do |form|
      form.password_field :password, labeled: false, placeholder: "Enter password"
    end

    assert_no_match(/label.*for.*password/, form_html)
    assert_match(/placeholder="Enter password"/, form_html)
  end

  test "select generates labeled field with hint" do
    form_html = styled_form_with(model: @post, local: true) do |form|
      form.select :status, [["Draft", "draft"], ["Published", "published"]], {}, { hint: "Choose status" }
    end

    assert_match(/label.*for.*status/, form_html)
    assert_match(/Choose status/, form_html)
    assert_match(/w-full px-3 py-2 border border-gray-300/, form_html)
  end

  test "select with labeled false uses simple styling" do
    form_html = styled_form_with(model: @post, local: true) do |form|
      form.select :status, [["Draft", "draft"]], {}, { labeled: false }
    end

    assert_no_match(/label.*for.*status/, form_html)
    assert_match(/block shadow-sm rounded-md/, form_html)
  end

  test "submit uses button_classes when no class provided" do
    form_html = styled_form_with(model: @post, local: true) do |form|
      form.submit "Save Post"
    end

    assert_match(/font-medium rounded-lg transition-colors/, form_html)
    assert_match(/bg-blue-600 hover:bg-blue-700 text-white/, form_html)
  end

  test "submit preserves custom class" do
    form_html = styled_form_with(model: @post, local: true) do |form|
      form.submit "Save Post", class: "custom-class"
    end

    assert_match(/custom-class/, form_html)
    assert_no_match(/bg-blue-600/, form_html)
  end

  test "custom label text works" do
    form_html = styled_form_with(model: @post, local: true) do |form|
      form.text_field :title, label: "Custom Title"
    end

    assert_match(/Custom Title/, form_html)
  end
end
