require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "error_messages_for returns nil when no errors" do
    post = posts(:one)

    result = error_messages_for(post)

    assert result.nil?
  end

  test "error_messages_for displays error messages when present" do
    post = Post.new
    post.valid?

    result = error_messages_for(post)

    assert_includes result, "2 errors prohibited this post from being saved"
    assert_includes result, "can&#39;t be blank"
    assert_includes result, "bg-red-50 border border-red-200"
    assert_includes result, "<li>Title"
    assert_includes result, "<li>Content"
  end

  test "error_messages_for uses correct model name" do
    user = User.new
    user.valid?

    result = error_messages_for(user)

    assert_includes result, "prohibited this user from being saved"
  end

  test "card helper creates basic card with default medium padding" do
    result = card { "test content" }

    assert_includes result, "bg-white rounded-lg shadow-sm border border-gray-200 p-6"
    assert_includes result, "test content"
    assert_includes result, "<div"
  end

  test "card helper with large padding" do
    result = card(padding: :large) { "content" }

    assert_includes result, "p-8"
    assert_includes result, "content"
  end

  test "card helper with small padding" do
    result = card(padding: :small) { "content" }

    assert_includes result, "p-4"
  end

  test "card helper with article tag" do
    result = card(tag: :article) { "content" }

    assert_includes result, "<article"
    assert_includes result, "content"
  end

  test "card helper with additional classes" do
    result = card(class: "extra-class") { "content" }

    assert_includes result, "bg-white rounded-lg shadow-sm border border-gray-200 p-6 extra-class"
  end

  test "card helper with header" do
    result = card(header: "Test Header") { "content" }

    assert_includes result, "<h1 class=\"text-3xl font-bold text-gray-900 mb-8\">Test Header</h1>"
    assert_includes result, "content"
  end

  test "card helper with header and custom header class" do
    result = card(header: "Custom Header", header_class: "text-xl font-medium") { "content" }

    assert_includes result, "<h1 class=\"text-xl font-medium\">Custom Header</h1>"
    assert_includes result, "content"
  end

  test "card helper without header shows no h1" do
    result = card { "content" }

    assert_not_includes result, "<h1"
    assert_includes result, "content"
  end
end
