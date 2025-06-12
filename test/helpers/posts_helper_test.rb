require "test_helper"

class PostsHelperTest < ActionView::TestCase
  test "post_status_classes returns green classes for published post" do
    post = posts(:one)

    result = post_status_classes(post)

    assert result == "bg-green-100 text-green-800"
  end

  test "post_status_classes returns yellow classes for draft post" do
    post = posts(:two)

    result = post_status_classes(post)

    assert result == "bg-yellow-100 text-yellow-800"
  end
end
