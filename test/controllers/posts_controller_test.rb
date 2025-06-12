require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
  end

  # Public access tests
  test "should get index with published posts only" do
    published_post = posts(:one)
    draft_post = posts(:two)
    published_post.update_column(:status, "published")
    draft_post.update_column(:status, "draft")

    get posts_url

    assert_response :success
  end

  test "should show published post" do
    @post.update_column(:status, "published")
    get post_url(@post)

    assert_response :success
  end

  test "should not show draft post to public" do
    @post.update_column(:status, "draft")
    get post_url(@post)

    assert_redirected_to posts_path
    assert flash[:alert].include?("Post not found")
  end
end
