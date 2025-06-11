require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
    @admin_user = users(:one)
    @commenter_user = users(:two)
  end

  # Public access tests
  test "should get index" do
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
    assert_equal "Post not found.", flash[:alert]
  end

  # Admin authentication tests
  test "should require admin for new" do
    get new_post_url

    assert_redirected_to new_session_path
  end

  test "should require admin for create" do
    post posts_url, params: { post: { title: "Test", content: "Content", status: "draft" } }

    assert_redirected_to new_session_path
  end

  test "should require admin for edit" do
    get edit_post_url(@post)

    assert_redirected_to new_session_path
  end

  test "should require admin for update" do
    patch post_url(@post), params: { post: { title: "Updated" } }

    assert_redirected_to new_session_path
  end

  test "should require admin for destroy" do
    delete post_url(@post)

    assert_redirected_to new_session_path
  end

  # Admin access tests
  test "admin should get new" do
    sign_in_as(@admin_user)
    get new_post_url

    assert_response :success
  end

  test "admin should create post" do
    sign_in_as(@admin_user)
    assert_difference("Post.count") do
      post posts_url, params: { post: { title: "New Post", content: "Content", status: "draft" } }
    end

    assert_redirected_to post_url(Post.last)
    assert_equal "Post was successfully created.", flash[:notice]
  end

  test "admin should get edit" do
    sign_in_as(@admin_user)
    get edit_post_url(@post)

    assert_response :success
  end

  test "admin should update post" do
    sign_in_as(@admin_user)
    patch post_url(@post), params: { post: { title: "Updated Title", content: "Updated content" } }

    assert_redirected_to post_url(@post)
    assert_equal "Post was successfully updated.", flash[:notice]
  end

  test "admin should destroy post" do
    sign_in_as(@admin_user)
    assert_difference("Post.count", -1) do
      delete post_url(@post)
    end

    assert_redirected_to posts_url
    assert_equal "Post was successfully deleted.", flash[:notice]
  end

  test "admin can see draft posts" do
    sign_in_as(@admin_user)
    @post.update_column(:status, "draft")
    get post_url(@post)

    assert_response :success
  end

  # Commenter access tests
  test "commenter should not access new" do
    sign_in_as(@commenter_user)
    get new_post_url

    assert_redirected_to root_path
    assert_equal "Access denied. Admin privileges required.", flash[:alert]
  end

  test "commenter should not create post" do
    sign_in_as(@commenter_user)
    assert_no_difference("Post.count") do
      post posts_url, params: { post: { title: "New Post", content: "Content", status: "draft" } }
    end
    assert_redirected_to root_path
  end

  test "commenter should not access edit" do
    sign_in_as(@commenter_user)
    get edit_post_url(@post)

    assert_redirected_to root_path
    assert_equal "Access denied. Admin privileges required.", flash[:alert]
  end

  test "commenter should not update post" do
    sign_in_as(@commenter_user)
    patch post_url(@post), params: { post: { title: "Updated Title" } }

    assert_redirected_to root_path
  end

  test "commenter should not destroy post" do
    sign_in_as(@commenter_user)
    assert_no_difference("Post.count") do
      delete post_url(@post)
    end
    assert_redirected_to root_path
  end

  # Validation tests
  test "should not create post without title" do
    sign_in_as(@admin_user)
    assert_no_difference("Post.count") do
      post posts_url, params: { post: { content: "Content", status: "draft" } }
    end
    assert_response :unprocessable_entity
  end

  test "should not create post without content" do
    sign_in_as(@admin_user)
    assert_no_difference("Post.count") do
      post posts_url, params: { post: { title: "Title", status: "draft" } }
    end
    assert_response :unprocessable_entity
  end

  test "should not update post with invalid data" do
    sign_in_as(@admin_user)
    patch post_url(@post), params: { post: { title: "", content: "" } }

    assert_response :unprocessable_entity
  end
end
